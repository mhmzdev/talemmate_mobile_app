part of 'bottom_bar.dart';

final _tabs = [
  _BottomBar(
    label: 'Home',
    path: AppRoutes.home,
    icon: LucideIcons.house,
  ),
  _BottomBar(
    label: 'Library',
    path: AppRoutes.library,
    icon: LucideIcons.library,
  ),
  _BottomBar(
    label: 'Tutor',
    path: AppRoutes.tutor,
    icon: LucideIcons.message_square,
  ),
  _BottomBar(
    label: 'Plan',
    path: AppRoutes.plan,
    icon: LucideIcons.calendar,
  ),
  _BottomBar(
    label: 'Progress',
    path: AppRoutes.progress,
    icon: LucideIcons.chart_column,
  ),
];
