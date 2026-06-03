import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/user/user.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

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
      final data = await UserRepo.ins.register(values);
      emit(
        state.copyWith(
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
    try {
      final data = await UserRepo.ins.init();
      emit(
        state.copyWith(
          init: state.init.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          init: state.init.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> login(Map<String, dynamic> values) async {
    emit(
      state.copyWith(
        login: state.login.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.login(values);
      emit(
        state.copyWith(
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

  Future<void> update() async {
    emit(
      state.copyWith(
        update: state.update.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.update();
      emit(
        state.copyWith(
          update: state.update.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          update: state.update.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> fetch() async {
    emit(
      state.copyWith(
        fetch: state.fetch.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.fetch();
      emit(
        state.copyWith(
          fetch: state.fetch.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          fetch: state.fetch.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> forgot() async {
    emit(
      state.copyWith(
        forgot: state.forgot.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.forgot();
      emit(
        state.copyWith(
          forgot: state.forgot.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          forgot: state.forgot.toFailed(fault: e),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(
      state.copyWith(
        logout: state.logout.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.logout();
      emit(
        state.copyWith(
          logout: state.logout.toSuccess(data: data),
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

  Future<void> deleteAccount() async {
    emit(
      state.copyWith(
        deleteAccount: state.deleteAccount.toLoading(),
      ),
    );
    try {
      final data = await UserRepo.ins.deleteAccount();
      emit(
        state.copyWith(
          deleteAccount: state.deleteAccount.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          deleteAccount: state.deleteAccount.toFailed(fault: e),
        ),
      );
    }
  }

  void reset() => emit(UserState.def());
}
