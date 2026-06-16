import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Shared top header for the signed-in tab screens (home, plan, …): a serif
/// [greeting] with an emphasized [name] on the next line, a muted [subtitle]
/// (date / week range), and an optional [trailing] action (e.g. the avatar).
class AppCoreHeader extends StatelessWidget {
  const AppCoreHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
    this.name,
    this.trailing,
  });

  final String greeting;
  final String subtitle;
  final String? name;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.h.t20 + Space.t.t12,
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text.rich(
                  TextSpan(
                    text: name == null ? greeting : '$greeting\n',
                    children: [
                      if (name != null)
                        TextSpan(text: name, style: AppText.h1.fra()),
                    ],
                  ),
                  style: AppText.h1.cl(AppTheme.c.text),
                ),
                Space.y.t04,
                Text(
                  subtitle,
                  style: AppText.b2
                      .cl(AppTheme.c.subText)
                      .copyWith(letterSpacing: 0.4),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[Space.x.t08, trailing!],
        ],
      ),
    );
  }
}
