import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';

/// {@template app_back_button}
/// AppBackButton widget.
/// {@endtemplate}
class AppBackButton extends StatelessWidget {
  /// {@macro app_back_button}
  const AppBackButton({
    super.key, // ignore: unused_element_parameter
    this.onTap,
    this.padding,
  });

  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppTouch(
      onTap: onTap ?? () => ''.pop(context),
      child: Container(
        padding: padding ?? Space.a.t12,
        decoration: BoxDecoration(
          color: AppTheme.isDark
              ? AppTheme.c.primary
              : AppTheme.c.subBackground,
          borderRadius: 360.radius(),
        ),
        child: Icon(
          LucideIcons.arrow_left,
          size: SpaceToken.t24,
        ),
      ),
    );
  }
}
