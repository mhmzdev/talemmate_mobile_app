part of '../tutor.dart';

/// Bottom sheet listing the student's past conversations (newest first). Tap to
/// reopen; the header button starts a new one.
class _History extends StatelessWidget {
  const _History();

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/tutor-history'),
    builder: (_) => const _History(),
  );

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final conversations = ChatCubit.c(context, true).state.conversations;

    return AppModalBase(
      dragger: true,
      title: 'Conversations',
      subtitle: conversations.isEmpty
          ? 'No conversations yet.'
          : 'Pick up where you left off.',
      actions: [
        AppButton(
          label: 'New conversation',
          icon: LucideIcons.plus,
          mainAxisSize: .max,
          size: .large,
          onTap: () {
            Navigator.pop(context);
            _SubjectPicker.show(context);
          },
        ),
      ],
      child: conversations.isEmpty
          ? const SizedBox.shrink()
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: conversations
                      .map((c) => _ConversationTile(conversation: c))
                      .toList(),
                ),
              ),
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final TutorConversation conversation;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final subject = _subjectName(context, conversation.subjectId);
    final title = conversation.title ?? subject ?? 'Chat';

    return Padding(
      padding: Space.b.t08,
      child: AppTouch(
        onTap: () {
          ChatCubit.c(context).openConversation(conversation.id);
          Navigator.pop(context);
        },
        hasSplash: false,
        child: Container(
          padding: Space.a.t12,
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            borderRadius: 12.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.message_circle,
                size: SpaceToken.t20,
                color: AppTheme.c.accent,
              ),
              Space.x.t12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      title,
                      style: AppText.b1.w(5).cl(AppTheme.c.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      [
                        ?subject,
                        _relativeTime(conversation.lastMessageAt),
                      ].join(' · '),
                      style: AppText.b2.cl(AppTheme.c.subText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact relative-time label (e.g. "5m ago", "3d ago").
String _relativeTime(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${(diff.inDays / 7).floor()}w ago';
}
