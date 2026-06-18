import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/providers/app.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/alerts/app_alert_base.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_avatar.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '_state.dart';
part 'widgets/_profile_header.dart';
part 'widgets/_glance.dart';
part 'widgets/_settings.dart';
part 'listeners/_logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    final state = _ScreenState.s(context, true);

    return Screen(
      belowBuilders: const [_LogoutListener()],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: Space.only(SpaceToken.t12, null, SpaceToken.t32, null),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              const _ProfileHeader(),
              Space.y.t08,
              const _GlanceCard(),

              // Account
              const _Section(
                title: 'Account',
                children: [
                  _SettingRow(
                    icon: LucideIcons.book_open,
                    label: 'Subjects & confidence',
                    value: '5 subjects',
                  ),
                  _SettingRow(
                    icon: LucideIcons.calendar,
                    label: 'Schedule & exams',
                    value: '3.5 hrs/day',
                  ),
                  _SettingRow(
                    icon: LucideIcons.library,
                    label: 'Material',
                    value: '42 items · 1.2 GB',
                  ),
                  _SettingRow(
                    icon: LucideIcons.flag,
                    label: 'Institution',
                    value: 'NUST · SEECS',
                    last: true,
                  ),
                ],
              ),

              // AI tutor
              _Section(
                title: 'AI tutor',
                aside: const AppAiPill(),
                children: [
                  _SettingToggle(
                    icon: LucideIcons.sparkles,
                    label: 'Show citations on every reply',
                    sub: 'Tutor links back to your source pages.',
                    value: state.citations,
                    onChanged: state.toggleCitations,
                  ),
                  const _SettingRow(
                    icon: LucideIcons.file_text,
                    label: 'Tutor scope',
                    value: 'Library + lectures',
                  ),
                  const _SettingRow(
                    icon: LucideIcons.book_open,
                    label: 'Reasoning depth',
                    value: 'Balanced',
                    last: true,
                  ),
                ],
              ),

              // Notifications
              _Section(
                title: 'Notifications',
                children: [
                  _SettingToggle(
                    icon: LucideIcons.bell,
                    label: 'Block reminders',
                    sub: 'Nudge me when a study block is starting.',
                    value: state.blockReminders,
                    onChanged: state.toggleBlockReminders,
                  ),
                  _SettingToggle(
                    icon: LucideIcons.clock,
                    label: 'Daily check-in',
                    sub: 'A gentle 8 PM reminder if I haven\'t studied.',
                    value: state.dailyCheckin,
                    onChanged: state.toggleDailyCheckin,
                  ),
                  _SettingToggle(
                    icon: LucideIcons.flag,
                    label: 'Exam countdown',
                    sub: '3-day, 1-day, and morning-of nudges.',
                    value: state.examCountdown,
                    onChanged: state.toggleExamCountdown,
                    last: true,
                  ),
                ],
              ),

              // Appearance
              _Section(
                title: 'Appearance',
                children: [
                  const _ThemeSelector(),
                  _SettingToggle(
                    icon: LucideIcons.quote,
                    label: 'Daily du\'a card',
                    sub: 'Show a verse on Home each morning.',
                    value: state.duaCard,
                    onChanged: state.toggleDuaCard,
                  ),
                  _SettingToggle(
                    icon: LucideIcons.calendar,
                    label: 'Hijri date alongside Gregorian',
                    value: state.hijri,
                    onChanged: state.toggleHijri,
                    last: true,
                  ),
                ],
              ),

              // Language
              _Section(
                title: 'Language',
                children: [
                  const _SettingRow(
                    icon: LucideIcons.languages,
                    label: 'App language',
                    value: 'English',
                  ),
                  _SettingToggle(
                    label: 'Urdu content rendering',
                    sub: 'Use Nastaliq for Urdu passages in your material.',
                    value: state.urduRendering,
                    onChanged: state.toggleUrduRendering,
                    trailing: Text(
                      'اُردو',
                      style: AppText.b1.cl(AppTheme.c.subText).urdu(),
                    ),
                    last: true,
                  ),
                ],
              ),

              // Privacy & data
              _Section(
                title: 'Privacy & data',
                children: [
                  _SettingRow(
                    icon: LucideIcons.leaf,
                    label: 'On-device processing',
                    value: 'On',
                    valueTone: AppTheme.c.success,
                  ),
                  _SettingToggle(
                    icon: LucideIcons.shield,
                    label: 'Cloud backup',
                    sub: 'Encrypted sync across your devices.',
                    value: state.cloudBackup,
                    onChanged: state.toggleCloudBackup,
                  ),
                  const _SettingRow(
                    icon: LucideIcons.download,
                    label: 'Export my data',
                  ),
                  const _SettingRow(
                    icon: LucideIcons.shield,
                    label: 'Privacy policy',
                    last: true,
                  ),
                ],
              ),

              // Support
              const _Section(
                title: 'Support',
                children: [
                  _SettingRow(
                    icon: LucideIcons.message_square,
                    label: 'Help & feedback',
                  ),
                  _SettingRow(
                    icon: LucideIcons.star,
                    label: 'Rate TaleemMate',
                  ),
                  _SettingRow(
                    icon: LucideIcons.info,
                    label: 'About',
                    value: 'v1.4.0 · build 218',
                    last: true,
                  ),
                ],
              ),

              Space.y.t24,
              Padding(
                padding: Space.h.t24,
                child: Column(
                  children: [
                    AppButton(
                      label: 'Sign out',
                      style: .creamy,
                      mainAxisSize: .max,
                      onTap: () => state.confirmSignOut(context),
                    ),
                    Space.y.t08,
                    AppTouch(
                      onTap: () {},
                      child: Padding(
                        padding: Space.v.t12,
                        child: Text(
                          'Delete account',
                          style: AppText.b1.w(5).cl(AppTheme.c.error),
                          textAlign: .center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Space.y.t08,
              Text(
                'Made with care · Lahore + Islamabad',
                style: AppText.b2.cl(AppTheme.c.subText).gm(),
                textAlign: .center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
