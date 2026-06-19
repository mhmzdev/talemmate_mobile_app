part of '../library.dart';

/// Opens the quiz-scope sheet for a subject, then (if the user confirms) pushes
/// the quiz route grounded on the chosen materials. All of the subject's
/// indexed [items] are pre-selected — tap Generate for a whole-subject quiz, or
/// uncheck some for a subset.
Future<void> _showQuizScope(
  BuildContext context,
  Subject subject,
  List<LibraryItem> items,
) async {
  final selected = await showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/quiz-scope'),
    builder: (_) => _QuizScopeSheet(subject: subject, items: items),
  );

  if (!context.mounted || selected == null || selected.isEmpty) return;
  AppRoutes.quiz.push(
    context,
    arguments: {'subjectId': subject.id, 'sourceItemIds': selected},
  );
}

class _QuizScopeSheet extends StatefulWidget {
  const _QuizScopeSheet({required this.subject, required this.items});

  final Subject subject;
  final List<LibraryItem> items;

  @override
  State<_QuizScopeSheet> createState() => _QuizScopeSheetState();
}

class _QuizScopeSheetState extends State<_QuizScopeSheet> {
  late final Set<String> _selected = {for (final i in widget.items) i.id};

  bool get _allSelected => _selected.length == widget.items.length;

  void _toggle(String id) => setState(() {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
  });

  void _toggleAll() => setState(() {
    if (_allSelected) {
      _selected.clear();
    } else {
      _selected
        ..clear()
        ..addAll(widget.items.map((i) => i.id));
    }
  });

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final count = _selected.length;
    final label = count == 1
        ? 'Generate quiz · 1 material'
        : 'Generate quiz · $count materials';

    return AppModalBase(
      dragger: true,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          const Align(
            alignment: .centerLeft,
            child: AppAiPill(text: 'AI QUIZ'),
          ),
          Space.y.t12,
          Text('Generate a quiz', style: AppText.h3),
          Space.y.t04,
          Text(
            '${widget.subject.name} · choose the material to base it on',
            style: AppText.b2.cl(AppTheme.c.subText),
          ),
          Space.y.t16,
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'MATERIALS',
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(letterSpacing: 1.2),
              ),
              AppTouch(
                onTap: _toggleAll,
                hasSplash: false,
                child: Text(
                  _allSelected ? 'Clear all' : 'Select all',
                  style: AppText.b2b.cl(AppTheme.c.accent),
                ),
              ),
            ],
          ),
          Space.y.t08,
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: widget.items
                    .map(
                      (item) => Padding(
                        padding: Space.b.t08,
                        child: _ScopeRow(
                          item: item,
                          selected: _selected.contains(item.id),
                          onTap: () => _toggle(item.id),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Space.y.t16,
          AppButton(
            label: label,
            mainAxisSize: .max,
            state: count == 0 ? .disabled : .def,
            onTap: count == 0
                ? null
                : () => Navigator.pop(context, _selected.toList()),
          ),
        ],
      ),
    );
  }
}

/// A selectable material row inside [_QuizScopeSheet]: a check box, the kind
/// badge, and the material name.
class _ScopeRow extends StatelessWidget {
  const _ScopeRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final LibraryItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final color = item.kind.badgeColor;

    return AppTouch(
      onTap: onTap,
      hasSplash: false,
      child: Container(
        padding: Space.a.t12,
        decoration: BoxDecoration(
          color: AppTheme.c.subBackground,
          borderRadius: 12.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.accent : AppTheme.c.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: .center,
              decoration: BoxDecoration(
                color: selected ? AppTheme.c.accent : Colors.transparent,
                borderRadius: 6.radius(),
                border: Border.all(
                  color: selected ? AppTheme.c.accent : AppTheme.c.border,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Icon(
                      LucideIcons.check,
                      size: 14,
                      color: AppTheme.c.onAccent,
                    )
                  : null,
            ),
            Space.x.t12,
            Container(
              width: 32,
              height: 32,
              alignment: .center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: 6.radius(),
              ),
              child: Text(
                item.kind.name.toUpperCase(),
                style: AppText.l1b.cl(color).copyWith(letterSpacing: 0.5),
              ),
            ),
            Space.x.t12,
            Expanded(
              child: Text(
                item.name,
                style: AppText.b1,
                maxLines: 1,
                overflow: .ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
