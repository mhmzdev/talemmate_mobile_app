part of '../onboarding.dart';

class _AddExamModal extends StatefulWidget {
  const _AddExamModal({required this.subjects, required this.onAdd});

  final List<_SubjectDraft> subjects;
  final ValueChanged<_ExamDraft> onAdd;

  @override
  State<_AddExamModal> createState() => _AddExamModalState();
}

class _AddExamModalState extends State<_AddExamModal> {
  String? _subjectId;
  ExamType _type = ExamType.midterm;
  DateTime _date = DateTime.now().add(const Duration(days: 30));

  /// Midnight today — the earliest selectable exam date (date-only so the
  /// current day is always included regardless of the time of day).
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  _SubjectDraft? get _selectedSubject {
    if (_subjectId == null) return null;
    for (final s in widget.subjects) {
      if (s.id == _subjectId) return s;
    }
    return null;
  }

  void _submit() {
    if (_subjectId == null) {
      UIFlash.error(context, 'Please select a subject first.');
      return;
    }
    final subject = _selectedSubject!;
    widget.onAdd(
      _ExamDraft()
        ..subjectId = subject.id
        ..subjectName = subject.nameCtrl.text.trim()
        ..subjectColorHex = subject.colorHex
        ..type = _type
        ..date = _date,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final daysAway = _date.difference(DateTime.now()).inDays;
    final dateStr = '${_date.day} ${_monthAbbr[_date.month - 1]}';
    final subject = _selectedSubject;
    final name = subject?.nameCtrl.text ?? '–';
    final previewText =
        '$name · ${_type.name.titleCase} · $dateStr · in $daysAway days';

    return AppModalBase(
      dragger: true,
      canPop: true,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const _ModalHeader(eyebrow: 'NEW EXAM', title: "When's the test?"),
          Space.y.t24,

          // SUBJECT
          Text(
            'SUBJECT',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          SubjectChips(
            subjects: widget.subjects.map((s) => s.toChipData()).toList(),
            selectedId: _subjectId,
            onSelect: (id) => setState(() => _subjectId = id),
            emptyMessage: 'No subjects added yet — go back to step 2.',
          ),
          Space.y.t16,

          // TYPE
          Text(
            'TYPE',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          _ExamTypeChips(
            selected: _type,
            onSelect: (t) => setState(() => _type = t),
          ),
          Space.y.t16,

          // DATE
          Text(
            'DATE',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          AppFormDateInput(
            name: _ExamFormKeys.date,
            initialValue: _date,
            // Exams can only be today or later — never in the past.
            firstDate: _today,
            dateFormat: DateFormat('dd MMM yyyy'),
            lastDate: _today.add(const Duration(days: 365)),
            placeholder: 'Select exam date',
            onChanged: (date) {
              if (date != null) setState(() => _date = date);
            },
          ),
          Space.y.t24,

          // Footer: preview + button
          Row(
            children: [
              Expanded(
                child: Text(
                  previewText,
                  style: AppText.b2.cl(AppTheme.c.subText),
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
              ),
              Space.x.t12,
              Expanded(
                child: AppButton(
                  icon: LucideIcons.plus,
                  label: 'Add exam',
                  onTap: _submit,
                  size: .large,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
