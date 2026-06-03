part of '../onboarding.dart';

class _ModalTextField extends StatelessWidget {
  const _ModalTextField({
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          label,
          style: AppText.l1b
              .cl(AppTheme.c.subText)
              .copyWith(letterSpacing: 1.2),
        ),
        Space.y.t08,
        TextField(
          controller: controller,
          style: AppText.b1,
          decoration: _modalInputDec(hint),
        ),
      ],
    );
  }
}
