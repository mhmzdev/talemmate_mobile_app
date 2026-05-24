import 'package:taleemmate/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UIFlash {
  static final iconLeft = -SpaceToken.t28;
  static final iconLeftSmall = -SpaceToken.t12;
  static const iconTopSmall = 10.0;

  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarPosition? position,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: message,
        backgroundColor: AppTheme.c.accent, //
        iconPositionLeft: iconLeft,
        iconPositionTop: 0,
        maxLines: 3,
      ),
      displayDuration: duration ?? 4.seconds,
      snackBarPosition: position ?? SnackBarPosition.top,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarPosition? position,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        textStyle: AppText.h3 + Colors.white,
        backgroundColor: AppTheme.c.success, //

        iconPositionLeft: iconLeftSmall,
        iconPositionTop: iconTopSmall,
        iconRotationAngle: 0,
        maxLines: 3,
      ),
      displayDuration: duration ?? 4.seconds,
      snackBarPosition: position ?? SnackBarPosition.top,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarPosition? position,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        backgroundColor: AppTheme.c.error, //
        maxLines: 3,
      ),
      displayDuration: duration ?? 4.seconds,
      snackBarPosition: position ?? SnackBarPosition.top,
    );
  }
}
