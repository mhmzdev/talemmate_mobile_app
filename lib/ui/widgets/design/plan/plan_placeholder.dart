import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';

/// Calm bordered placeholder for the study-plan surfaces — used for the loading,
/// empty, and error states on both the home and plan screens.
class PlanPlaceholder extends StatelessWidget {
  const PlanPlaceholder({
    super.key,
    required this.message,
    this.busy = false,
    this.onRetry,
  });

  final String message;
  final bool busy;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      padding: Space.a.t24,
      margin: Space.t.t08,
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        children: [
          if (busy) ...[
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            Space.y.t12,
          ],
          Text(
            message,
            style: AppText.b1.cl(AppTheme.c.subText),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            Space.y.t16,
            AppButton(label: 'Try again', onTap: onRetry, size: .small),
          ],
        ],
      ),
    );
  }
}
