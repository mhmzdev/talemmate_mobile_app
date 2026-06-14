import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/tutor/tutor_conversation.dart';
import 'package:taleemmate/core/models/tutor/tutor_message.dart';
import 'package:taleemmate/core/models/tutor/tutor_settings.dart';
import 'package:taleemmate/repos/chat/chat_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class ChatCubit extends Cubit<ChatState> {
  static ChatCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<ChatCubit>(context, listen: listen);

  /// [repo] is injectable for unit tests; production uses the singleton.
  ChatCubit({ChatRepo? repo})
    : _repo = repo ?? ChatRepo.ins,
      super(ChatState.def());

  final ChatRepo _repo;

  StreamSubscription<List<Map<String, dynamic>>>? _convSub;
  StreamSubscription<List<Map<String, dynamic>>>? _msgSub;

  /// Session uid lifecycle (ADR-014) — driven by the auth-transition listeners.
  /// Subscribes to the user's conversation list and loads their settings.
  void initUid(String uid) {
    emit(state.copyWith(userId: uid));
    _convSub?.cancel();
    _convSub = _repo.watchConversations(uid).listen((rows) {
      final conversations = rows.map(TutorConversation.fromJson).toList();
      // Keep the active conversation's snapshot (title, lastMessageAt,
      // groundedSourceCount) in sync with its persisted row.
      final active = state.active;
      var refreshed = active;
      if (active != null) {
        for (final c in conversations) {
          if (c.id == active.id) {
            refreshed = c;
            break;
          }
        }
      }
      emit(
        state.copyWith(conversations: conversations, active: refreshed),
      );
    });
    loadSettings();
  }

  /// Clears the uid and all loaded chat state on logout.
  void resetUid() {
    _convSub?.cancel();
    _msgSub?.cancel();
    emit(ChatState.def());
  }

  /// Creates a new per-subject conversation and makes it active.
  Future<void> startConversation(String subjectId) async {
    final uid = state.userId;
    if (uid == null) return;
    try {
      final raw = await _repo.createConversation(uid, subjectId);
      _activate(TutorConversation.fromJson(raw));
    } on Fault catch (e) {
      emit(state.copyWith(send: state.send.toFailed(fault: e)));
    }
  }

  /// Opens an existing conversation by id (from the history list).
  void openConversation(String id) {
    final matches = state.conversations.where((c) => c.id == id);
    if (matches.isEmpty) return;
    _activate(matches.first);
  }

  void _activate(TutorConversation convo) {
    emit(state.copyWith(active: convo, messages: const []));
    _msgSub?.cancel();
    _msgSub = _repo.watchMessages(convo.id).listen((rows) {
      emit(state.copyWith(messages: rows.map(TutorMessage.fromJson).toList()));
    });
  }

  /// Sends a grounded turn in the active conversation. The user + AI messages
  /// arrive via the Drift message stream; this only tracks the request state.
  Future<void> send(String text) async {
    final active = state.active;
    final trimmed = text.trim();
    if (active == null || trimmed.isEmpty) return;
    emit(state.copyWith(send: state.send.toLoading()));
    try {
      final raw = await _repo.send(
        conversation: active.toJson(),
        history: state.messages.map((m) => m.toJson()).toList(),
        userText: trimmed,
        settings: state.settings.data?.toJson(),
      );
      emit(
        state.copyWith(
          send: state.send.toSuccess(data: TutorMessage.fromJson(raw)),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(send: state.send.toFailed(fault: e)));
    }
  }

  /// Loads (or defaults) the user's tutor settings.
  Future<void> loadSettings() async {
    final uid = state.userId;
    if (uid == null) return;
    emit(state.copyWith(settings: state.settings.toLoading()));
    try {
      final raw = await _repo.settings(uid);
      final value = raw == null
          ? TutorSettings(userId: uid)
          : TutorSettings.fromJson(raw);
      emit(state.copyWith(settings: state.settings.toSuccess(data: value)));
    } on Fault catch (e) {
      emit(state.copyWith(settings: state.settings.toFailed(fault: e)));
    }
  }

  /// Persists updated tutor settings.
  Future<void> saveSettings(TutorSettings value) async {
    emit(state.copyWith(settings: state.settings.toLoading()));
    try {
      await _repo.saveSettings(value.toJson());
      emit(state.copyWith(settings: state.settings.toSuccess(data: value)));
    } on Fault catch (e) {
      emit(state.copyWith(settings: state.settings.toFailed(fault: e)));
    }
  }

  @override
  Future<void> close() {
    _convSub?.cancel();
    _msgSub?.cancel();
    return super.close();
  }

  void reset() => emit(ChatState.def());
}
