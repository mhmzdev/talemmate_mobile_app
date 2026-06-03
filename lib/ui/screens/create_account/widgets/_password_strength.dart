part of '../create_account.dart';

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength();

  static const _labels = ['', 'Weak', 'Fair', 'Strong', 'Very Strong'];

  static Color _segmentColor(int index, int strength) {
    if (index >= strength) return const Color(0xFF3A3A4A);
    return switch (strength) {
      1 => const Color(0xFFE05252),
      2 => const Color(0xFFE09A2B),
      3 => const Color(0xFF4CAF50),
      _ => const Color(0xFF2ECC71),
    };
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context, true);
    final strength = screenState.passwordStrength;

    return Row(
      children: [
        for (int i = 0; i < 4; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: _segmentColor(i, strength),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (i < 3) Space.x.t04,
        ],
        Space.x.t08,
        Text(
          strength > 0 ? _labels[strength] : '',
          style: AppText.b2.cl(AppTheme.c.subText),
        ),
      ],
    );
  }
}
