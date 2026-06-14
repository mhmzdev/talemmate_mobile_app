import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/services/firebase/crash/crashlytics.dart';
import 'package:taleemmate/services/http/alice.dart';

part '_data.dart';
part '_model.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final currentPath = context.currentPath;

    return Material(
      color: AppTheme.c.background,
      elevation: 0,
      child: GestureDetector(
        onLongPress: () => AppAlice.ins.showInspector(),
        child: Container(
          padding: Space.z.sb().t(12),
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            border: Border(
              top: BorderSide(
                color: AppTheme.c.border,
              ),
            ),
          ),
          child: Row(
            children: _tabs.map((tab) {
              final isActive = tab.path == currentPath;
              final color = isActive
                  ? AppTheme.c.primary
                  : AppTheme.c.subText.addOpacity(.5);

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (isActive) return;
                    tab.path.pushReplace(context);
                    ''.trackUserAction(
                      'bottom_bar_tapped ${tab.path}',
                    );
                  },
                  child: Column(
                    children: [
                      Space.y.t04,
                      Icon(
                        tab.icon,
                        color: color,
                        size: SpaceToken.t24,
                      ),
                      Space.y.t04,
                      Text(
                        tab.label,
                        style: AppText.b2.gm() + color,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
