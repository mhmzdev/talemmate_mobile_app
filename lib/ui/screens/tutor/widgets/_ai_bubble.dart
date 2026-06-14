part of '../tutor.dart';

/// Left-aligned tutor reply: markdown answer + citation chips + follow-up chips
/// + optional kicker question.
class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.message});

  final TutorMessage message;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final chatCubit = ChatCubit.c(context);
    final chatState = chatCubit.state;

    final showCitations =
        chatState.settings.data?.showCitationsOnEveryReply ?? true;
    final citations = showCitations ? message.citations : const <Citation>[];

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppMedia.width * 0.88),
        child: Container(
          padding: Space.a.t16,
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            borderRadius: 16.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              GptMarkdown(
                message.text,
                style: AppText.b1.cl(AppTheme.c.text),
              ),
              if (citations.isNotEmpty) ...[
                Space.y.t12,
                Wrap(
                  spacing: SpaceToken.t08,
                  runSpacing: SpaceToken.t08,
                  children: citations
                      .map((c) => _CitationChip(citation: c))
                      .toList(),
                ),
              ],
              if (message.kickerQuestion != null) ...[
                Space.y.t12,
                Text(
                  message.kickerQuestion!,
                  style: AppText.b2
                      .cl(AppTheme.c.accent)
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              if (message.followUpPoints.isNotEmpty) ...[
                Space.y.t12,
                Wrap(
                  spacing: SpaceToken.t08,
                  runSpacing: SpaceToken.t08,
                  children: message.followUpPoints
                      .map((f) => _FollowUpChip(point: f))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
