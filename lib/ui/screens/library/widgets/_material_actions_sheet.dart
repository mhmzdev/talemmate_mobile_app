part of '../library.dart';

enum _MaterialAction { open, tutor, delete }

/// Opens the "…" overflow sheet for a material, then runs the chosen action on
/// the (valid) screen context once the sheet has popped.
Future<void> _showMaterialActions(
  BuildContext context,
  LibraryItem item,
  String? subjectName,
) async {
  final cubit = LibraryCubit.c(context);
  final action = await showModalBottomSheet<_MaterialAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/material-actions'),
    builder: (_) => _MaterialActionsSheet(item: item, subjectName: subjectName),
  );

  if (!context.mounted) return;
  switch (action) {
    case _MaterialAction.open:
      UIFlash.info(context, 'Document viewer coming soon');
    case _MaterialAction.tutor:
      UIFlash.info(context, 'Tutor coming soon');
    case _MaterialAction.delete:
      _confirmDeleteMaterial(context, cubit, item);
    case null:
      break;
  }
}

void _confirmDeleteMaterial(
  BuildContext context,
  LibraryCubit cubit,
  LibraryItem item,
) {
  showAppAlert(
    context,
    routeName: 'confirm-delete-material',
    icon: const Icon(LucideIcons.trash_2),
    title: 'Delete this material?',
    subtitle: 'It will be removed from your library on this device.',
    actions: [
      AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
      AppAlertAction(
        label: 'Delete',
        isDestructive: true,
        onTap: () {
          Navigator.pop(context);
          cubit.remove(item.id);
        },
      ),
    ],
  );
}

class _MaterialActionsSheet extends StatelessWidget {
  const _MaterialActionsSheet({required this.item, this.subjectName});

  final LibraryItem item;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final color = item.kind.badgeColor;
    final meta = [
      ?subjectName,
      item.fileSize.readableSize,
    ].join(' · ');

    return AppModalBase(
      dragger: true,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: .center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: 8.radius(),
                ),
                child: Text(
                  item.kind.name.toUpperCase(),
                  style: AppText.l1b.cl(color).copyWith(letterSpacing: 0.5),
                ),
              ),
              Space.x.t12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      item.name,
                      style: AppText.h3,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    Space.y.t04,
                    Text(meta, style: AppText.b2.cl(AppTheme.c.subText)),
                  ],
                ),
              ),
            ],
          ),
          Space.y.t16,
          _SheetAction(
            icon: LucideIcons.book_open,
            title: 'Open document',
            subtitle: 'Read & annotate',
            onTap: () => Navigator.pop(context, _MaterialAction.open),
          ),
          Space.y.t08,
          _SheetAction(
            icon: LucideIcons.message_circle,
            title: 'Ask the tutor about this',
            subtitle: 'Start a grounded chat',
            onTap: () => Navigator.pop(context, _MaterialAction.tutor),
          ),
          Space.y.t08,
          _SheetAction(
            icon: LucideIcons.trash_2,
            title: 'Delete from library',
            subtitle: 'Remove this material from this device',
            destructive: true,
            onTap: () => Navigator.pop(context, _MaterialAction.delete),
          ),
          Space.y.t16,
          AppButton(
            label: 'Cancel',
            style: .creamy,
            mainAxisSize: .max,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final tint = destructive ? AppTheme.c.error : AppTheme.c.text;

    return AppTouch(
      onTap: onTap,
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
            Icon(icon, size: 20, color: tint),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: AppText.b1.w(5).cl(tint)),
                  Space.y.t04,
                  Text(
                    subtitle,
                    style: AppText.b2.cl(AppTheme.c.subText),
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
