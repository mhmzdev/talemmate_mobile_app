part of '../schedule_editor.dart';

/// Bottom sheet for adding an exam. Captures the editor [_ScreenState] in [show]
/// (the modal sits outside the editor's provider scope) and dispatches the new
/// exam to it on submit.
class _AddExamSheet extends StatefulWidget {
  const _AddExamSheet({required this.state});

  final _ScreenState state;

  static Future<void> show(BuildContext context) {
    final state = _ScreenState.s(context);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/add-exam'),
      builder: (_) => _AddExamSheet(state: state),
    );
  }

  @override
  State<_AddExamSheet> createState() => _AddExamSheetState();
}

class _AddExamSheetState extends State<_AddExamSheet> {
  static const _types = ['Midterm', 'Final', 'Quiz', 'Viva'];

  String? _subjectId;
  String _type = 'Midterm';
  DateTime _date = DateTime.now().add(const Duration(days: 30));

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _submit() {
    if (_subjectId == null) {
      UIFlash.error(context, 'Pick a subject first.');
      return;
    }
    widget.state.addExam(subjectId: _subjectId!, date: _date, label: _type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppModalBase(
      dragger: true,
      title: 'Add an exam',
      subtitle: 'Near-exam subjects get front-loaded in your plan.',
      actions: [
        AppButton(label: 'Add exam', mainAxisSize: .max, onTap: _submit),
        AppButton(
          label: 'Cancel',
          style: .creamy,
          mainAxisSize: .max,
          onTap: () => Navigator.pop(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            'SUBJECT',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          SubjectChips(
            subjects: widget.state.subjects
                .map(
                  (s) => SubjectChipData(
                    id: s.id,
                    label: s.name,
                    colorHex: s.colorHex,
                  ),
                )
                .toList(),
            selectedId: _subjectId,
            onSelect: (id) => setState(() => _subjectId = id),
            emptyMessage: 'No subjects yet — add one from Subjects first.',
          ),
          Space.y.t16,
          Text(
            'TYPE',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types
                .map(
                  (t) => AppChoiceChip(
                    label: t,
                    selected: _type == t,
                    onTap: () => setState(() => _type = t),
                  ),
                )
                .toList(),
          ),
          Space.y.t16,
          Text(
            'DATE',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          AppFormDateInput(
            name: 'exam_date',
            initialValue: _date,
            firstDate: _today,
            lastDate: _today.add(const Duration(days: 365)),
            dateFormat: DateFormat('dd MMM yyyy'),
            placeholder: 'Select exam date',
            onChanged: (date) {
              if (date != null) setState(() => _date = date);
            },
          ),
        ],
      ),
    );
  }
}
