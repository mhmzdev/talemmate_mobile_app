import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';

part '_state.dart';

class StepwiseLoaderScreen extends StatelessWidget {
  const StepwiseLoaderScreen({super.key});

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

  static const _stepLabels = [
    'Saving your subjects',
    'Indexing uploaded material',
    'Calibrating today\'s plan',
    'Almost there — readying your home screen',
  ];

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);
    state.startSequenceIfNeeded(context);

    return Screen(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Space.y.t32,
            Text(
              'STEP 4 OF 4 · PERSONALISING',
              style: AppText.l1b.cl(AppTheme.c.subText).copyWith(letterSpacing: 1.2),
            ),
            Space.y.t12,
            Text('Finishing setup', style: AppText.h1),
            Space.y.t08,
            Text(
              'Building your study plan from what you\'ve told us.',
              style: AppText.b1.cl(AppTheme.c.subText),
            ),
            Space.y.t32,
            for (int i = 0; i < _stepLabels.length; i++) ...[
              _StepRow(label: _stepLabels[i], stepState: state.stepStates[i]),
              Space.y.t16,
            ],
            const Spacer(),
            const _LoaderFooter(),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.stepState});

  final String label;
  final int stepState; // 0=pending, 1=active, 2=done

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: switch (stepState) {
            2 => const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
            1 => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            _ => Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.c.border, width: 2),
                ),
              ),
          },
        ),
        Space.x.t16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.b1.cl(
                  stepState == 0 ? AppTheme.c.subText : AppTheme.c.text,
                ),
              ),
              if (stepState == 1)
                Text(
                  'Working on it...',
                  style: AppText.b2.cl(const Color(0xFFE09A2B)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoaderFooter extends StatelessWidget {
  const _LoaderFooter();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Padding(
      padding: Space.b.t24,
      child: Text.rich(
        TextSpan(
          style: AppText.b2.cl(AppTheme.c.subText),
          children: [
            const TextSpan(text: 'Patience — '),
            TextSpan(
              text: 'صَبْر',
              style: AppText.b1.cl(AppTheme.c.subText).copyWith(fontStyle: FontStyle.italic),
            ),
            const TextSpan(text: ' — you\'ll be set up in a few seconds.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
