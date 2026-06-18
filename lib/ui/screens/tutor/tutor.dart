import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/tutor/citation.dart';
import 'package:taleemmate/core/models/tutor/follow_up_point.dart';
import 'package:taleemmate/core/models/tutor/tutor_conversation.dart';
import 'package:taleemmate/core/models/tutor/tutor_message.dart';
import 'package:taleemmate/core/models/tutor/tutor_settings.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_icon_button.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/alerts/app_alert_base.dart';
import 'package:taleemmate/ui/widgets/design/library/subject_chips.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_choice_chip.dart';
import 'package:taleemmate/ui/widgets/design/misc/progress_dots.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';

part '_state.dart';
part 'listeners/_send.dart';
part 'widgets/_ai_bubble.dart';
part 'widgets/_user_bubble.dart';
part 'widgets/_composer.dart';
part 'widgets/_empty.dart';
part 'widgets/_subject_picker.dart';
part 'widgets/_history.dart';
part 'widgets/_settings_sheet.dart';
part 'widgets/_typing.dart';
part 'widgets/_citation_chip.dart';
part 'widgets/_follow_up_chip.dart';

class TutorScreen extends StatelessWidget {
  const TutorScreen({super.key});

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
    // Subjects power the picker / conversation labels. LibraryCubit.load()
    // no-ops without a session uid and caches across tabs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) LibraryCubit.c(context).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context, true);

    return Screen(
      keyboardHandler: true,
      resizeToAvoidBottomInset: true,
      bottomBarHeightChanged: screenState.setBottomBarHeight,
      belowBuilders: const [_SendListener()],
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            final hasActive = state.active != null;
            return Column(
              crossAxisAlignment: .stretch,
              children: [
                const _ChatBar(),
                Expanded(
                  child: hasActive
                      ? _MessageList(state: state)
                      : const _Empty(),
                ),
                if (hasActive) const _Composer(),
                // Clear the floating bottom bar so the composer stays visible.
                SizedBox(
                  height: screenState.bottomBarHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Top bar: active conversation title + history / new-chat / settings actions.
class _ChatBar extends StatelessWidget {
  const _ChatBar();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = ChatCubit.c(context, true).state;
    final active = state.active;
    final title = active == null
        ? 'Tutor'
        : (active.title ?? _subjectName(context, active.subjectId) ?? 'Chat');

    return Container(
      padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
      decoration: BoxDecoration(
        color: AppTheme.c.background,
        border: Border(bottom: BorderSide(color: AppTheme.c.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppText.b1.w(6).cl(AppTheme.c.text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Space.x.t08,
                    const AppAiPill(),
                  ],
                ),
                if (active != null) ...[
                  Space.y.t04,
                  Text(
                    _headerSubtitle(context, active),
                    style: AppText.b2.cl(AppTheme.c.subText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Space.x.t16,
          AppIconButton(
            key: const ValueKey('tutor_history'),
            icon: LucideIcons.history,
            onTap: () => _History.show(context),
          ),
          Space.x.t04,
          AppIconButton(
            key: const ValueKey('tutor_new'),
            icon: LucideIcons.square_pen,
            onTap: () => _SubjectPicker.show(context),
          ),
          Space.x.t04,
          AppIconButton(
            key: const ValueKey('tutor_settings'),
            icon: LucideIcons.settings_2,
            onTap: () => _SettingsSheet.show(context),
          ),
        ],
      ),
    );
  }
}

/// Reverse-scrolling message list (newest at the bottom) + typing indicator.
class _MessageList extends StatelessWidget {
  const _MessageList({required this.state});

  final ChatState state;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final messages = state.messages;
    final showTyping = state.send.isLoading;

    if (messages.isEmpty && !showTyping) {
      return Center(
        child: Padding(
          padding: Space.a.t32,
          child: Text(
            'Ask your first question to get started.',
            style: AppText.b2.cl(AppTheme.c.subText),
            textAlign: .center,
          ),
        ),
      );
    }

    return ListView(
      reverse: true,
      padding: Space.sym(SpaceToken.t16, SpaceToken.t16),
      children: [
        if (showTyping) const _Typing(),
        ...messages.reversed.map(
          (m) => Padding(
            padding: Space.b.t12,
            child: m.isAI ? _AiBubble(message: m) : _UserBubble(message: m),
          ),
        ),
      ],
    );
  }
}

/// Subject display name for [subjectId] from the app-level LibraryCubit.
String? _subjectName(BuildContext context, String subjectId) {
  final subjects = LibraryCubit.c(context).state.subjects;
  for (final s in subjects) {
    if (s.id == subjectId) return s.name;
  }
  return null;
}

/// Subject brand-colour hex for [subjectId], if known.
String? _subjectColorHex(BuildContext context, String subjectId) {
  final subjects = LibraryCubit.c(context).state.subjects;
  for (final s in subjects) {
    if (s.id == subjectId) return s.colorHex;
  }
  return null;
}

/// Header subtitle for an active conversation — subject plus, once the first
/// reply lands, how many materials it was grounded in.
String _headerSubtitle(BuildContext context, TutorConversation active) {
  final subject = _subjectName(context, active.subjectId) ?? 'Tutor chat';
  final n = active.groundedSourceCount;
  if (n <= 0) return subject;
  return '$subject · grounded in $n source${n == 1 ? '' : 's'}';
}
