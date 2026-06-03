import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/onboarding/onboarding_data.dart';
import 'package:taleemmate/repos/onboarding/onboarding_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  static OnboardingCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<OnboardingCubit>(context, listen: listen);

  OnboardingCubit() : super(OnboardingState.def());

  Future<void> save(OnboardingData data) async {
    emit(state.copyWith(save: state.save.toLoading()));
    try {
      final raw = await OnboardingRepo.ins.save(data.toJson());
      emit(state.copyWith(save: state.save.toSuccess(data: OnboardingData.fromJson(raw))));
    } on Fault catch (e) {
      emit(state.copyWith(save: state.save.toFailed(fault: e)));
    }
  }

  Future<void> complete(OnboardingData data) async {
    emit(state.copyWith(complete: state.complete.toLoading()));
    try {
      final raw = await OnboardingRepo.ins.complete(data.toJson());
      emit(state.copyWith(complete: state.complete.toSuccess(data: OnboardingData.fromJson(raw))));
    } on Fault catch (e) {
      emit(state.copyWith(complete: state.complete.toFailed(fault: e)));
    }
  }

  void reset() => emit(OnboardingState.def());
}
