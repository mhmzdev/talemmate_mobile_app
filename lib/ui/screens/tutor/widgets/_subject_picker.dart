part of '../tutor.dart';

/// Bottom sheet to choose the subject a new conversation is grounded in.
class _SubjectPicker extends StatelessWidget {
  const _SubjectPicker();

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/tutor-subject'),
    builder: (_) => const _SubjectPicker(),
  );

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final subjects = LibraryCubit.c(context, true).state.subjects;

    return AppModalBase(
      dragger: true,
      title: 'Start a chat',
      subtitle: 'Pick the subject your questions are about.',
      child: SubjectChips(
        subjects: subjects
            .map(
              (s) => SubjectChipData(
                id: s.id,
                label: s.name,
                colorHex: s.colorHex,
              ),
            )
            .toList(),
        selectedId: null,
        onSelect: (id) {
          ChatCubit.c(context).startConversation(id);
          Navigator.pop(context);
        },
        emptyMessage: 'No subjects yet — add them from onboarding or Library.',
      ),
    );
  }
}
