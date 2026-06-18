import 'package:flutter/widgets.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';

/// {@template app_back_button}
/// AppIconButton widget.
/// {@endtemplate}
class AppIconButton extends StatelessWidget {
  /// {@macro app_icon_button}
  const AppIconButton({
    super.key, // ignore: unused_element_parameter
    required this.onTap,
    this.padding,
    required this.icon,
  });

  final VoidCallback onTap;
  final IconData icon;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppTouch(
      onTap: onTap,
      child: Container(
        padding: padding ?? Space.a.t12,
        decoration: BoxDecoration(
          color: AppTheme.isDark
              ? AppTheme.c.primary
              : AppTheme.c.subBackground,
          borderRadius: 360.radius(),
        ),
        child: Icon(
          icon,
          size: SpaceToken.t24,
        ),
      ),
    );
  }
}
