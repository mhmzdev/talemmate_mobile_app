import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/router/routes.dart';

import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_avatar.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_circle_icon_button.dart';

part '_state.dart';
part 'widgets/_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    return const Screen(
      keyboardHandler: true,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [_Header()],
        ),
      ),
    );
  }
}
