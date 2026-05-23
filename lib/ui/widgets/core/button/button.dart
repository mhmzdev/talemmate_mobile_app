import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/animations/bottom_animation.dart';

part '_enums.dart';
part '_model.dart';
part '_data.dart';

/// A themed, animated button supporting multiple styles, sizes, and states.
///
/// Handles press animations and disabled state internally.
/// Supply at least one of [label] or [icon].
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    this.onTap,
    this.label,
    this.icon,
    this.iconColor,
    this.textColor,
    this.borderRadius = .normal,
    this.size = .medium,
    this.style = .primary,
    this.mainAxisSize = .min,
    this.state = .def,
    this.margin = .zero,
    this.padding,
    this.mainAxisAlignment = .center,
  });

  final EdgeInsets margin;

  /// Overrides the default size-based padding.
  final EdgeInsets? padding;
  final AppButtonSize size;
  final AppButtonState state;
  final AppButtonStyle style;
  final VoidCallback? onTap;
  final String? label;
  final IconData? icon;

  /// Overrides the icon color derived from [style].
  final Color? iconColor;

  /// Overrides the text color derived from [style].
  final Color? textColor;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final AppButtonRadius borderRadius;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  late AppButtonState state;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    if (oldWidget.state != widget.state) {
      state = widget.state;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onTapDown(TapDownDetails? details) {
    if (_isDisabled()) return;
    setState(() {
      state = AppButtonState.pressed;
    });
  }

  void _onTapUp(TapUpDetails? details) {
    if (_isDisabled()) return;
    setState(() {
      state = AppButtonState.def;
    });
  }

  void _onTapCancel() {
    if (_isDisabled()) return;
    setState(() {
      state = AppButtonState.def;
    });
  }

  bool _isDisabled() => widget.state == AppButtonState.disabled;

  @override
  Widget build(BuildContext context) {
    final data = _mapPropsToData()[widget.style]!;
    final disabledSurface =
        data.surface[AppButtonState.disabled] ?? AppTheme.c.primary;
    final disabledText =
        data.text[AppButtonState.disabled] ?? AppTheme.c.subText;
    var surface = data.surface[state] ?? data.surface[AppButtonState.def]!;

    var border = widget.style.isCreamy
        ? AppTheme.c.subText.withValues(alpha: 0.5)
        : surface;

    var text =
        widget.textColor ?? data.text[state] ?? data.text[AppButtonState.def]!;
    final textStyle = _mapSizeToFontSize()[widget.size]!;
    var padding = Space.sym(
      SpaceToken.t12,
      SpaceToken.t16,
    );

    if (_isDisabled()) {
      surface = disabledSurface;
      border = disabledSurface;
      text = disabledText;
    }

    if (widget.size == AppButtonSize.small) {
      padding = Space.v.t12 + Space.h.t16;
    }

    final radius = _mapRadiusToBorderRadius()[widget.borderRadius]!;

    return GestureDetector(
      onTap: state.isDisabled ? null : widget.onTap,
      onTapUp: state.isDisabled ? null : _onTapUp,
      onTapDown: state.isDisabled ? null : _onTapDown,
      onTapCancel: state.isDisabled ? null : _onTapCancel,
      child: AnimatedContainer(
        duration: AppProps.medium,
        clipBehavior: Clip.antiAlias,
        margin: widget.margin,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: border),
          borderRadius: radius,
        ),
        child: AnimatedContainer(
          duration: AppProps.medium,
          padding: widget.padding ?? padding,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius - (radius * 0.1),
          ),
          child: Row(
            mainAxisSize: widget.mainAxisSize,
            mainAxisAlignment: widget.mainAxisAlignment,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.iconColor ?? text,
                  size: textStyle.fontSize! * 1.2,
                ),
                if (widget.label != null) Space.x.t12,
              ],
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: textStyle + text + FontWeight.w500,
                ),
            ],
          ).withBottomAnimation(),
        ),
      ),
    );
  }
}
