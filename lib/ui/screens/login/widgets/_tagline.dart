part of '../login.dart';

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Column(
      children: [
        Text(
          'علم نور ہے',
          style: AppText.h2.urdu().cl(AppTheme.c.text),
          textAlign: .center,
        ),
        Space.y.t04,
        Text(
          'Knowledge is light.',
          style: AppText.b2.cl(AppTheme.c.subText),
          textAlign: .center,
        ),
      ],
    );
  }
}
