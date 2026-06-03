part of '../onboarding.dart';

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                eyebrow,
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(letterSpacing: 1.2),
              ),
              Space.y.t04,
              Text(title, style: AppText.h1),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: .circle,
              color: AppTheme.c.subBackground,
            ),
            child: Icon(Icons.close, size: 16, color: AppTheme.c.subText),
          ),
        ),
      ],
    );
  }
}
