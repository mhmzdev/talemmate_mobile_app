import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_edge_card.dart';
import 'package:taleemmate/ui/widgets/design/plan/plan_visuals.dart';

part '_state.dart';
part 'widgets/_top_bar.dart';
part 'widgets/_timer_ring.dart';
part 'widgets/_block_card.dart';
part 'widgets/_tutor_panel.dart';
part 'widgets/_actions.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final block = ModalRoute.of(context)!.settings.arguments as StudyBlock;

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(block),
      child: _Body(block: block),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Screen(
      scaffoldBackgroundColor: AppTheme.c.specBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            _TopBar(block: block),
            Expanded(
              child: SingleChildScrollView(
                padding: Space.h.t20,
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Space.y.t24,
                    const _TimerRing(),
                    Space.y.t32,
                    _BlockCard(block: block),
                    Space.y.t16,
                    _TutorPanel(block: block),
                    Space.y.t24,
                  ],
                ),
              ),
            ),
            Padding(
              padding: Space.a.t20,
              child: _Actions(block: block),
            ),
          ],
        ),
      ),
    );
  }
}
