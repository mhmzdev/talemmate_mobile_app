import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A single action rendered in [AppAlertBase]'s divided action row.
class AppAlertAction {
  const AppAlertAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
}

/// Shows a centered [AppAlertBase] dialog. The centered counterpart to
/// `showModalBottomSheet` + `AppModalBase`.
///
/// ```dart
/// showAppAlert(
///   context,
///   icon: const Icon(LucideIcons.logOut),
///   title: 'Sign out of TaleemMate?',
///   subtitle: 'Your study material and progress stay saved on this device.',
///   actions: [
///     AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
///     AppAlertAction(label: 'Sign out', isDestructive: true, onTap: onConfirm),
///   ],
/// );
/// ```
Future<T?> showAppAlert<T>(
  BuildContext context, {
  Widget? icon,
  String? title,
  String? subtitle,
  List<AppAlertAction> actions = const [],
  bool barrierDismissible = true,
  String? routeName,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    routeSettings: RouteSettings(name: '/alert/$routeName'),
    builder: (_) => AppAlertBase(
      icon: icon,
      title: title,
      subtitle: subtitle,
      actions: actions,
    ),
  );
}

/// Centered alert dialog. Compose via named params — no required fields.
class AppAlertBase extends StatelessWidget {
  const AppAlertBase({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.actions = const [],
  });

  /// Optional icon shown in a circular badge above the title.
  final Widget? icon;

  /// Serif heading at the top of the alert.
  final String? title;

  /// Body copy shown below [title].
  final String? subtitle;

  /// Flat-text buttons rendered in a divided row at the bottom.
  final List<AppAlertAction> actions;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final hasText = title != null || subtitle != null;

    return Dialog(
      backgroundColor: AppTheme.c.background,
      insetPadding: Space.sym(SpaceToken.t32, SpaceToken.t24),
      shape: RoundedRectangleBorder(borderRadius: 22.radius()),
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: Space.a.t24,
            child: Column(
              mainAxisSize: .min,
              children: [
                if (icon != null) ...[
                  _IconBadge(icon: icon!),
                  if (hasText) Space.y.t16,
                ],
                if (title != null)
                  Text(title!, style: AppText.h2, textAlign: .center),
                if (title != null && subtitle != null) Space.y.t08,
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppText.b1.cl(AppTheme.c.subText),
                    textAlign: .center,
                  ),
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[
            Container(height: 1, color: AppTheme.c.border),
            _ActionRow(actions: actions),
          ],
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpaceToken.t32 + SpaceToken.t32,
      height: SpaceToken.t32 + SpaceToken.t32,
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconTheme(
          data: IconThemeData(color: AppTheme.c.subText, size: SpaceToken.t24),
          child: icon,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.actions});

  final List<AppAlertAction> actions;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: actions
            .asMap()
            .entries
            .expand(
              (entry) => [
                if (entry.key > 0)
                  Container(width: 1, color: AppTheme.c.border),
                Expanded(child: _ActionButton(action: entry.value)),
              ],
            )
            .toList(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final AppAlertAction action;

  @override
  Widget build(BuildContext context) {
    final color = action.isDestructive ? AppTheme.c.error : AppTheme.c.primary;

    return InkWell(
      onTap: action.onTap,
      child: Padding(
        padding: Space.a.t24,
        child: Center(
          child: Text(
            action.label,
            style: AppText.b1.w(6).cl(color),
            textAlign: .center,
          ),
        ),
      ),
    );
  }
}
