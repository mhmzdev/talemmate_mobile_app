import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/headless/focus_handler.dart';

/// Flexible bottom-sheet base. Compose via named params — no required fields.
///
/// Typical usage:
/// ```dart
/// AppModalBase(
///   icon: Icon(LucideIcons.logOut),
///   title: 'Sign out?',
///   subtitle: 'Your library and progress remain on this device.',
///   actions: [
///     AppButton(label: 'Sign out', style: .error, onTap: onConfirm, mainAxisSize: .max),
///     AppButton(label: 'Cancel', style: .creamy, onTap: onCancel, mainAxisSize: .max),
///   ],
/// )
/// ```
class AppModalBase extends StatelessWidget {
  const AppModalBase({
    super.key,
    // Header
    this.icon,
    this.title,
    this.subtitle,
    // Body
    this.child,
    this.expanded = false,
    // Footer
    this.actions = const [],
    // Layout
    this.padding,
    this.bottomSafe = true,
    this.dragger = true,
    // Behaviour
    this.canPop = true,
    this.backgroundColor,
  });

  /// Optional icon shown in a rounded square beside the title.
  final Widget? icon;

  /// Serif heading at the top of the sheet.
  final String? title;

  /// Body copy shown below [title].
  final String? subtitle;

  /// Arbitrary content between the header and [actions].
  final Widget? child;

  /// Wraps [child] in [Expanded] — use for full-height sheets.
  final bool expanded;

  /// Buttons rendered in a column at the bottom, 8 dp apart.
  final List<Widget> actions;

  /// Overrides the default horizontal + vertical padding on the content area.
  final EdgeInsets? padding;
  final bool bottomSafe;
  final bool dragger;
  final bool canPop;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final hasHeader = icon != null || title != null || subtitle != null;
    final contentPadding = padding ?? Space.sym(SpaceToken.t24, SpaceToken.t20);

    return PopScope(
      canPop: canPop,
      child: GestureDetector(
        onTap: () => FocusHandler.tap(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: 22.top(),
            color: backgroundColor ?? AppTheme.c.background,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Space.y.t12,
                if (dragger) _Dragger(),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: contentPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (hasHeader)
                          _Header(
                            icon: icon,
                            title: title,
                            subtitle: subtitle,
                          ),
                        if (hasHeader && (child != null || actions.isNotEmpty))
                          Space.y.t16,
                        if (child != null)
                          _Body(expanded: expanded, child: child!),
                        if (child != null && actions.isNotEmpty) Space.y.t16,
                        if (actions.isNotEmpty) _Actions(actions: actions),
                      ],
                    ),
                  ),
                ),
                if (bottomSafe) Space.bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dragger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: Space.b.t12,
        decoration: BoxDecoration(
          borderRadius: 360.radius(),
          color: AppTheme.c.subText.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.icon, this.title, this.subtitle});

  final Widget? icon;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final hasText = title != null || subtitle != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.c.subBackground,
              borderRadius: AppProps.radiusMd.radius(),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  color: AppTheme.c.subText,
                  size: 18,
                ),
                child: icon!,
              ),
            ),
          ),
          if (hasText) Space.x.t16,
        ],
        if (hasText)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: AppText.h3),
                if (title != null && subtitle != null) Space.y.t04,
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppText.b2 + AppTheme.c.subText,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.expanded, required this.child});

  final Widget child;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (expanded) return Expanded(child: child);
    return child;
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) Space.y.t08,
          actions[i],
        ],
      ],
    );
  }
}
