import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/quotes/quote.dart';
import 'package:taleemmate/repos/quotes/quotes_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  static QuotesCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<QuotesCubit>(context, listen: listen);

  QuotesCubit() : super(QuotesState.def());

  Future<void> today() async {
    emit(
      state.copyWith(
        today: state.today.toLoading(),
      ),
    );
    try {
      final data = await QuotesRepo.ins.today();
      emit(
        state.copyWith(
          today: state.today.toSuccess(data: data),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          today: state.today.toFailed(fault: e),
        ),
      );
    }
  }

  void reset() => emit(QuotesState.def());
}
