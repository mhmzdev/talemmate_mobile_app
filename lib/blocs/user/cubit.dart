import 'package:firebase_auth/firebase_auth.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/user/user.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/logging/app_log.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class UserCubit extends Cubit<UserState> {
  static UserCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<UserCubit>(context, listen: listen);

  UserCubit() : super(UserState.def());

  Future<void> register(Map<String, dynamic> values) async {
    emit(
      state.copyWith(
        register: state.register.toLoading(),
      ),
    );
    try {
      final user = await UserRepo.ins.register(values);
      final raw = await UserRepo.ins.fetchProfile(user.uid);
      final data = UserData.fromJson(raw);
      emit(
        state.copyWith(
          user: user,
          userData: data,
          register: state.register.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          register: state.register.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> init() async {
    emit(
      state.copyWith(
        init: state.init.toLoading(),
      ),
    );
    // Wait for Firebase to settle the restored session before routing. The
    // first auth event can be a transient null on relaunch (before disk
    // restore finishes), so fall back to currentUser once it has settled.
    final first = await UserRepo.ins.authChanges().first;
    await _resolveSession(first ?? UserRepo.ins.currentUser);
  }

  Future<void> _resolveSession(User? user) async {
    if (isClosed) return;
    if (user == null) {
      emit(state.copyWith(init: state.init.toSuccess()));
      return;
    }
    try {
      final raw = await UserRepo.ins.fetchProfile(user.uid);
      if (isClosed) return;
      if (raw.isEmpty) {
        // authed but no profile doc → treat as logged out
        await UserRepo.ins.logout();
        if (isClosed) return;
        emit(state.copyWith(init: state.init.toSuccess()));
        return;
      }
      final data = UserData.fromJson(raw);
      emit(
        state.copyWith(
          user: user,
          userData: data,
          init: state.init.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      if (isClosed) return;
      emit(state.copyWith(init: state.init.toFailed(fault: e)));
    }
  }

  Future<void> login(Map<String, dynamic> values) async {
    emit(
      state.copyWith(
        login: state.login.toLoading(),
      ),
    );
    try {
      final user = await UserRepo.ins.login(values);
      final raw = await UserRepo.ins.fetchProfile(user.uid);
      final data = UserData.fromJson(raw);
      emit(
        state.copyWith(
          user: user,
          userData: data,
          login: state.login.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          login: state.login.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> completeOnboarding([Map<String, dynamic>? extra]) async {
    final uid = state.user?.uid ?? state.userData?.uid;
    if (uid == null) return;
    try {
      await UserRepo.ins.completeOnboarding(uid, extra);
      final raw = await UserRepo.ins.fetchProfile(uid);
      if (isClosed || raw.isEmpty) return;
      emit(state.copyWith(userData: UserData.fromJson(raw)));
    } catch (e, st) {
      'completeOnboarding failed: $e\n$st'.appLog(level: AppLogLevel.error);
    }
  }

  Future<void> logout() async {
    emit(
      state.copyWith(
        logout: state.logout.toLoading(),
      ),
    );
    try {
      await UserRepo.ins.logout();
      emit(
        state.copyWith(
          logout: state.logout.toSuccess(),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          logout: state.logout.toFailed(fault: e),
        ),
      );
    }
  }

  // --- not wired to any UI yet; kept (mocked) for upcoming features --- //

  Future<void> fetch() async {
    emit(state.copyWith(fetch: state.fetch.toLoading()));
    try {
      final raw = await UserRepo.ins.fetch();
      emit(
        state.copyWith(
          fetch: state.fetch.toSuccess(data: UserData.fromJson(raw)),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(fetch: state.fetch.toFailed(fault: e)));
    }
  }

  Future<void> update() async {
    emit(state.copyWith(update: state.update.toLoading()));
    try {
      final raw = await UserRepo.ins.update();
      emit(
        state.copyWith(
          update: state.update.toSuccess(data: UserData.fromJson(raw)),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(update: state.update.toFailed(fault: e)));
    }
  }

  Future<void> forgot() async {
    emit(state.copyWith(forgot: state.forgot.toLoading()));
    try {
      await UserRepo.ins.forgot();
      emit(state.copyWith(forgot: state.forgot.toSuccess()));
    } on Fault catch (e) {
      emit(state.copyWith(forgot: state.forgot.toFailed(fault: e)));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(deleteAccount: state.deleteAccount.toLoading()));
    try {
      await UserRepo.ins.deleteAccount();
      emit(state.copyWith(deleteAccount: state.deleteAccount.toSuccess()));
    } on Fault catch (e) {
      emit(
        state.copyWith(deleteAccount: state.deleteAccount.toFailed(fault: e)),
      );
    }
  }

  void reset() => emit(UserState.def());
}
