part of '../focus.dart';

/// Bottom action row — deep-link into a fresh tutor chat for the block's
/// subject ("I'm stuck"), or mark the block done (records a SessionMetric via
/// [PlanCubit.markBlockDone]) and return to Home.
class _Actions extends StatelessWidget {
  const _Actions({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        AppButton(
          label: 'Test yourself',
          icon: LucideIcons.circle_question_mark,
          mainAxisSize: .max,
          onTap: () => AppRoutes.quiz.push(
            context,
            arguments: {
              'subjectId': block.subjectId,
              'topicId': block.topicId,
            },
          ),
        ),
        Space.y.t08,
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'I\'m stuck',
                icon: LucideIcons.life_buoy,
                style: .creamy,
                mainAxisSize: .max,
                onTap: () {
                  ChatCubit.c(context).startConversation(block.subjectId);

                  ''.pop(context); // pop focus
                  AppRoutes.tutor.pushReplace(context); // push replace tutor (bottom bar)
                },
              ),
            ),
            Space.x.t08,
            Expanded(
              child: AppButton(
                label: 'Mark block done',
                icon: LucideIcons.check,
                mainAxisSize: .max,
                onTap: () {
                  PlanCubit.c(context).markBlockDone(block);
                  AppRoutes.focus.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
