import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/animations/bottom_animation.dart';
import 'package:taleemmate/ui/painters/painters.dart';

import 'package:taleemmate/ui/widgets/core/screen/screen.dart';

part '_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();

    Future.delayed(1.5.seconds, () {
      if (!mounted) return;
      AppRoutes.login.pushReplace(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Screen(
      keyboardHandler: true,
      padding: Space.a.t16,
      child: SafeArea(
        child: Center(
          child: CustomPaint(
            painter: const AppIconPainter(),
            size: AppIconPainter.size(96),
          ).withBottomAnimation(),
        ),
      ),
    );
  }
}
