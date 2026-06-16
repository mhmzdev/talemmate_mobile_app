import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/repos/library/library_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  static LibraryCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<LibraryCubit>(context, listen: listen);

  /// [repo] is injectable for unit tests; production uses the singleton.
  LibraryCubit({LibraryRepo? repo})
    : _repo = repo ?? LibraryRepo.ins,
      super(LibraryState.def());

  final LibraryRepo _repo;

  /// Session uid lifecycle (ADR-014) — driven by the auth-transition listeners.
  void initUid(String uid) => emit(state.copyWith(userId: uid));

  /// The loaded [Subject] for [id], or null if unknown — used by surfaces that
  /// only hold a `subjectId` (study blocks, conversations) to resolve a name
  /// and brand colour.
  Subject? subjectById(String id) {
    for (final s in state.subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Clears the uid plus all loaded materials/subjects on logout.
  void resetUid() => emit(LibraryState.def());

  /// One-shot load of the signed-in user's materials + all subjects. No-ops if
  /// no session uid is set. Re-run by pull-to-refresh and after add/remove.
  Future<void> load() async {
    final uid = state.userId;
    if (uid == null) return;
    emit(state.copyWith(load: state.load.toLoading()));
    try {
      final rawItems = await _repo.materials(uid);
      final rawSubs = await _repo.subjects(uid);
      final items = rawItems.map(LibraryItem.fromJson).toList();
      final subs = rawSubs.map(Subject.fromJson).toList();
      emit(
        state.copyWith(
          subjects: subs,
          load: state.load.toSuccess(data: items),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(load: state.load.toFailed(fault: e)));
    }
  }

  Future<void> add(LibraryItem item) async {
    emit(state.copyWith(add: state.add.toLoading()));
    try {
      await _repo.add(item.toJson());
      emit(state.copyWith(add: state.add.toSuccess(data: item)));
      await load();
    } on Fault catch (e) {
      emit(state.copyWith(add: state.add.toFailed(fault: e)));
    }
  }

  Future<void> remove(String id) async {
    emit(state.copyWith(remove: state.remove.toLoading()));
    try {
      await _repo.remove(id);
      emit(state.copyWith(remove: state.remove.toSuccess()));
      await load();
    } on Fault catch (e) {
      emit(state.copyWith(remove: state.remove.toFailed(fault: e)));
    }
  }

  void reset() => emit(LibraryState.def());
}
