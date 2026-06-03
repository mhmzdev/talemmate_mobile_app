part of '../onboarding.dart';

class _AddExamModal extends StatefulWidget {
  const _AddExamModal({
    required this.subjects,
    required this.onAdd,
  });

  final List<_SubjectDraft> subjects;
  final ValueChanged<_ExamDraft> onAdd;

  @override
  State<_AddExamModal> createState() => _AddExamModalState();
}

class _AddExamModalState extends State<_AddExamModal> {
  String? _subjectId;
  ExamType _type = ExamType.midterm;
  DateTime _date = DateTime.now().add(const Duration(days: 30));

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
    final previewText = subject != null
        ? '${subject.nameCtrl.text} · ${_type.name.titleCase} · $dateStr · in $daysAway days'
        : '– · ${_type.name.titleCase} · $dateStr · in $daysAway days';

    return AppModalBase(
      dragger: true,
      canPop: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW EXAM',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t04,
                    Text("When's the test?", style: AppText.h1),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.c.subBackground,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppTheme.c.subText,
                  ),
                ),
              ),
            ],
          ),
          Space.y.t24,

          // SUBJECT
          Text(
            'SUBJECT',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          if (widget.subjects.isEmpty)
            Text(
              'No subjects added yet — go back to step 2.',
              style: AppText.b2.cl(AppTheme.c.subText),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in widget.subjects)
                  GestureDetector(
                    onTap: () => setState(() => _subjectId = s.id),
                    child: Container(
                      padding: Space.a.t08 + Space.h.t04,
                      decoration: BoxDecoration(
                        color: _subjectId == s.id
                            ? AppTheme.c.primary
                            : Colors.transparent,
                        borderRadius: 30.radius(),
                        border: Border.all(
                          color: _subjectId == s.id
                              ? AppTheme.c.primary
                              : AppTheme.c.border,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(
                                int.parse(
                                  s.colorHex.replaceFirst(
                                    '#',
                                    '0xFF',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Space.x.t08,
                          Text(
                            s.nameCtrl.text,
                            style: AppText.b1.cl(
                              _subjectId == s.id
                                  ? AppTheme.c.background
                                  : AppTheme.c.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
          Wrap(
            children: [
              for (int i = 0; i < ExamType.values.length; i++) ...[
                if (i > 0) Space.x.t08,
                GestureDetector(
                  onTap: () => setState(
                    () => _type = ExamType.values[i],
                  ),
                  child: Container(
                    padding: Space.a.t08 + Space.h.t04,
                    decoration: BoxDecoration(
                      color: _type == ExamType.values[i]
                          ? AppTheme.c.primary
                          : Colors.transparent,
                      borderRadius: 8.radius(),
                      border: Border.all(
                        color: _type == ExamType.values[i]
                            ? AppTheme.c.primary
                            : AppTheme.c.border,
                      ),
                    ),
                    child: Text(
                      ExamType.values[i].name.titleCase,
                      textAlign: .center,
                      style: AppText.b1
                          .w(6)
                          .cl(
                            _type == ExamType.values[i]
                                ? AppTheme.c.background
                                : AppTheme.c.text,
                          ),
                    ),
                  ),
                ),
              ],
            ],
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
            firstDate: DateTime.now(),
            dateFormat: DateFormat('dd MMM yyyy'),
            lastDate: DateTime.now().add(
              const Duration(days: 365),
            ),
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
                  overflow: TextOverflow.ellipsis,
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
