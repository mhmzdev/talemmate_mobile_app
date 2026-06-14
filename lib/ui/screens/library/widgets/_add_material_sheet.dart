part of '../library.dart';

class _AddMaterialSheet extends StatefulWidget {
  const _AddMaterialSheet();

  @override
  State<_AddMaterialSheet> createState() => _AddMaterialSheetState();

  /// Opens the post-onboarding "Add new material" sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/add-material'),
      builder: (_) => const _AddMaterialSheet(),
    );
  }
}

class _AddMaterialSheetState extends State<_AddMaterialSheet> {
  final List<LibraryItem> _picked = [];
  String? _subjectId;
  bool _saving = false;

  List<Subject> get _subjects => LibraryCubit.c(context).state.subjects;

  Subject? get _selectedSubject {
    for (final s in _subjects) {
      if (s.id == _subjectId) return s;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final subs = LibraryCubit.c(context).state.subjects;
    _subjectId = subs.isEmpty ? null : subs.first.id;
  }

  Future<void> _pick(Future<List<PickedMaterial>> Function() picker) async {
    try {
      final picks = await picker();
      if (picks.isEmpty || !mounted) return;
      final uid = LibraryCubit.c(context).state.userId ?? '';
      final subject = _selectedSubject;
      // Persist each picked file to stable storage before listing it.
      final items = await Future.wait(
        picks.map(
          (p) => libraryItemForPick(
            pick: p,
            userId: uid,
            subjectId: subject?.id,
            colorHex: subject?.colorHex,
          ),
        ),
      );
      if (!mounted) return;
      setState(() => _picked.addAll(items));
    } catch (e) {
      if (mounted) UIFlash.error(context, 'Could not add that.');
    }
  }

  Future<void> _confirm() async {
    if (_picked.isEmpty) {
      Navigator.pop(context);
      return;
    }
    setState(() => _saving = true);
    final cubit = LibraryCubit.c(context);
    final materialCubit = MaterialCubit.c(context);
    final added = List<LibraryItem>.from(_picked);
    for (final item in added) {
      await cubit.add(item);
    }
    // Kick off background text extraction for each (fire-and-forget) — the
    // library list reflects each row's status as it settles.
    for (final item in added) {
      materialCubit.process(item);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppModalBase(
      dragger: true,
      title: 'Add material',
      subtitle: 'Attach it to a subject so it lands in the right section.',
      actions: [
        AppButton(
          label: _picked.isEmpty
              ? 'Add to library'
              : 'Add ${_picked.length} to library',
          mainAxisSize: .max,
          size: .large,
          onTap: _saving ? null : _confirm,
        ),
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
            'ADD TO SUBJECT',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          SubjectChips(
            subjects: _subjects
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
            emptyMessage: 'No subjects yet — this material will be unsorted.',
          ),
          Space.y.t16,
          Row(
            children: [
              _SourceButton(
                icon: LucideIcons.file,
                label: 'Files',
                onTap: () => _pick(MaterialPicker.pickFiles),
              ),
              Space.x.t08,
              _SourceButton(
                icon: LucideIcons.image,
                label: 'Photos',
                onTap: () => _pick(MaterialPicker.pickImages),
              ),
              Space.x.t08,
              _SourceButton(
                icon: LucideIcons.camera,
                label: 'Camera',
                onTap: () => _pick(() async {
                  final shot = await MaterialPicker.captureImage();
                  return shot == null ? const [] : [shot];
                }),
              ),
            ],
          ),
          if (_picked.isNotEmpty) ...[
            Space.y.t16,
            Text(
              'ADDED SO FAR',
              style: AppText.l1b
                  .cl(AppTheme.c.subText)
                  .copyWith(letterSpacing: 1.2),
            ),
            Space.y.t08,
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: _picked.expand((item) {
                    return [
                      LibraryItemTile(
                        item: item,
                        subjectName: _selectedSubject?.name,
                        trailing: AppTouch(
                          onTap: () => setState(() => _picked.remove(item)),
                          hasSplash: false,
                          child: Icon(
                            LucideIcons.x,
                            size: 18,
                            color: AppTheme.c.subText,
                          ),
                        ),
                      ),
                      Space.y.t08,
                    ];
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Expanded(
      child: AppTouch(
        onTap: onTap,
        hasSplash: false,
        child: Container(
          padding: Space.v.t12,
          alignment: .center,
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            borderRadius: 10.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: AppTheme.c.text),
              Space.y.t04,
              Text(label, style: AppText.b2.cl(AppTheme.c.text)),
            ],
          ),
        ),
      ),
    );
  }
}
