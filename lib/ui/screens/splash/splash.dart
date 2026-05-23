import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/ui/painters/painters.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';

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

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Screen(
      keyboardHandler: true,
      padding: Space.a.t16,
      child: SafeArea(
        child: Column(
          // crossAxisAlignment: .stretch,
          children: [
            Space.y.t24,
            CustomPaint(
              painter: const AppIconPainters(),
              size: AppIconPainters.s(128),
            ),
            Space.y.t24,
            CustomPaint(
              painter: AppIconPainters(
                fg: AppTheme.c.primary,
                bg: AppTheme.c.subBackground,
              ),
              size: AppIconPainters.s(128),
            ),
            Space.y.t24,
            AppButton(
              label: 'Primary',
              onTap: () {},
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Primary Disabled',
              onTap: () {},
              state: .disabled,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Creamy',
              onTap: () {},
              style: .creamy,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Creamy Disabled',
              onTap: () {},
              style: .creamy,
              state: .disabled,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Danger',
              onTap: () {},
              style: .error,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Danger Disabled',
              onTap: () {},
              style: .error,
              state: .disabled,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Success',
              onTap: () {},
              style: .success,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
            AppButton(
              label: 'Success Disabled',
              onTap: () {},
              style: .success,
              state: .disabled,
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t12,
          ],
        ),
      ),
    );
  }
}
