part of '../onboarding.dart';

class _StepMaterial extends StatelessWidget {
  const _StepMaterial();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Padding(
      padding: Space.h.t20,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'STEP 4 OF 4 · MATERIAL',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  Text('Bring your notes in.', style: AppText.h1),
                  Space.y.t04,
                  Text(
                    'Upload slides, past papers, or handwritten notes. I\'ll index them for study sessions.',
                    style: AppText.b1.cl(AppTheme.c.subText),
                  ),
                  Space.y.t24,

                  GestureDetector(
                    onTap: () =>
                        UIFlash.info(context, 'File upload coming soon'),
                    child: Container(
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: 12.radius(),
                        border: Border.all(color: AppTheme.c.border),
                      ),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            Icons.upload_file_outlined,
                            size: 32,
                            color: AppTheme.c.subText,
                          ),
                          Space.y.t08,
                          Text(
                            'Tap to add files',
                            style: AppText.b1.cl(AppTheme.c.subText),
                          ),
                          Text(
                            'PDF, images, notes, slides',
                            style: AppText.b2.cl(AppTheme.c.subText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Space.y.t16,

                  Row(
                    children: [
                      _SourceChip(
                        label: 'Files',
                        icon: LucideIcons.file,
                        onTap: () =>
                            UIFlash.info(context, 'File upload coming soon'),
                      ),
                      Space.x.t08,
                      _SourceChip(
                        label: 'Photos',
                        icon: LucideIcons.image,
                        onTap: () =>
                            UIFlash.info(context, 'File upload coming soon'),
                      ),
                      Space.x.t08,
                      _SourceChip(
                        label: 'Camera',
                        icon: LucideIcons.camera,
                        onTap: () =>
                            UIFlash.info(context, 'File upload coming soon'),
                      ),
                    ],
                  ),

                  Space.y.t24,

                  Text(
                    'ADDED SO FAR',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t12,
                  for (final file in state.files) ...[
                    _FileItem(file: file),
                    Space.y.t08,
                  ],

                  Space.y.t08,
                  Text(
                    'Files are encrypted and only used to generate your study content. We never share them.',
                    style: AppText.b2.cl(AppTheme.c.subText),
                  ),
                  Space.y.t24,
                ],
              ),
            ),
          ),
          Space.y.t12,
          AppButton(
            label: 'Finish setup',
            onTap: () => state.finish(context),
            mainAxisSize: .max,
            size: .large,
          ),
          Space.y.t08,
          Text(
            'You can add more material any time from Library.',
            style: AppText.b2.cl(AppTheme.c.subText),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
          decoration: BoxDecoration(
            color: AppTheme.c.subBackground,
            borderRadius: 12.radius(),
            border: Border.all(color: AppTheme.c.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: AppTheme.c.text),
              Space.y.t08,
              Text(label, style: AppText.b2),
            ],
          ),
        ),
      ),
    );
  }
}
