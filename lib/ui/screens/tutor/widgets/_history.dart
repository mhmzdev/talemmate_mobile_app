part of '../tutor.dart';

/// Bottom sheet listing the student's past conversations, grouped by recency
/// (Today / Yesterday / Earlier). Tap a card to reopen; the header button
/// starts a new one; each card can be deleted.
class _History extends StatelessWidget {
  const _History();

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/tutor-history'),
    builder: (_) => const _History(),
  );

  static const _order = [_Bucket.today, _Bucket.yesterday, _Bucket.earlier];

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final conversations = ChatCubit.c(context, true).state.conversations;

    final groups = <_Bucket, List<TutorConversation>>{};
    for (final c in conversations) {
      (groups[_bucketOf(c.lastMessageAt)] ??= []).add(c);
    }

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
          onTap: () {
            ''.pop(context);
            _SubjectPicker.show(context);
          },
        ),
      ],
      child: conversations.isEmpty
          ? const SizedBox.shrink()
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: AppMedia.safeHeight * .8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: _order
                      .where((b) => groups[b]?.isNotEmpty ?? false)
                      .expand(
                        (b) => [
                          _SectionLabel(label: b.name.toUpperCase()),
                          ...groups[b]!.map(
                            (c) => _ConversationTile(conversation: c),
                          ),
                        ],
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: Space.only(SpaceToken.t12, null, SpaceToken.t08),
    child: Text(
      label,
      style: AppText.l1b.cl(AppTheme.c.subText).copyWith(letterSpacing: 1.2),
    ),
  );
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final TutorConversation conversation;

  void _confirmDelete(BuildContext context) {
    showAppAlert(
      context,
      icon: const Icon(LucideIcons.trash_2),
      title: 'Delete conversation?',
      subtitle: 'This removes the chat and its messages permanently.',
      routeName: 'delete-conversation',
      actions: [
        AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
        AppAlertAction(
          label: 'Delete',
          isDestructive: true,
          onTap: () {
            Navigator.pop(context);
            ChatCubit.c(context).deleteConversation(conversation.id);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final subject = _subjectName(context, conversation.subjectId);
    final dotColor =
        _subjectColorHex(context, conversation.subjectId)?.toColor() ??
        AppTheme.c.accent;
    final title = conversation.title ?? subject ?? 'Chat';

    return AppTouch(
      onTap: () {
        ChatCubit.c(context).openConversation(conversation.id);
        Navigator.pop(context);
      },
      hasSplash: false,
      child: Padding(
        padding: Space.v.t12,
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: Space.t.t04,
              child: Container(
                width: SpaceToken.t08,
                height: SpaceToken.t08,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            ),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppText.h3b.cl(AppTheme.c.text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Space.x.t12,
                      Text(
                        _conversationTime(conversation.lastMessageAt),
                        style: AppText.b2.cl(AppTheme.c.subText),
                      ),
                    ],
                  ),
                  Space.y.t08,
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      if (subject != null)
                        Container(
                          padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
                          decoration: BoxDecoration(
                            color: AppTheme.isDark
                                ? AppTheme.c.specBackground
                                : AppTheme.c.subBackground,
                            borderRadius: 999.radius(),
                            border: Border.all(color: AppTheme.c.border),
                          ),
                          child: Text(
                            subject,
                            style: AppText.b2.cl(AppTheme.c.subText),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      AppTouch(
                        key: ValueKey('tutor_delete_${conversation.id}'),
                        onTap: () => _confirmDelete(context),
                        hasSplash: false,
                        child: Icon(
                          LucideIcons.trash_2,
                          size: SpaceToken.t20,
                          color: AppTheme.c.subText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recency bucket for the conversation list section headers.
enum _Bucket { today, yesterday, earlier }

_Bucket _bucketOf(DateTime t) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(t.year, t.month, t.day);
  final days = today.difference(day).inDays;
  if (days <= 0) return _Bucket.today;
  if (days == 1) return _Bucket.yesterday;
  return _Bucket.earlier;
}

/// Calendar-style timestamp: `2m` / `1h` today, weekday this week, `Jun 8` older.
String _conversationTime(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return DateFormat('EEE').format(time);
  return DateFormat('MMM d').format(time);
}
