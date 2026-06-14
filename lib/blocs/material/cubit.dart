import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/repos/material/material_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  static MaterialCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<MaterialCubit>(context, listen: listen);

  MaterialCubit() : super(MaterialState.def());

  /// Runs Gemini/direct text extraction for [item] in the background. The item
  /// id rides in `meta` so listeners can correlate which row settled. The
  /// library list reflects status via its row (re-read on these transitions);
  /// this state mainly drives the trigger + surfaces extraction faults.
  Future<void> process(LibraryItem item) async {
    emit(
      state.copyWith(
        process: state.process.toLoading(meta: item.id),
      ),
    );
    try {
      final raw = await MaterialRepo.ins.extract(item.toJson());
      emit(
        state.copyWith(
          process: state.process.toSuccess(
            data: LibraryItem.fromJson(raw),
            meta: item.id,
          ),
        ),
      );
    } on Fault catch (e) {
      emit(
        state.copyWith(
          process: state.process.toFailed(fault: e, meta: item.id),
        ),
      );
    }
  }

  void reset() => emit(MaterialState.def());
}
