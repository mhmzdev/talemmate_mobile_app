part of '../onboarding.dart';

class _StepMaterial extends StatelessWidget {
  const _StepMaterial();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);
    final attachSubject = state.subjectNameFor(state.materialSubjectId);

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

                  // Attach picked material to a subject (so the Library can
                  // group it). Defaults to the first subject.
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'ADD TO SUBJECT',
                        style: AppText.l1b
                            .cl(AppTheme.c.subText)
                            .copyWith(letterSpacing: 1.2),
                      ),
                      Text(
                        'Required',
                        style: AppText.b2.cl(AppTheme.c.subText),
                      ),
                    ],
                  ),
                  Space.y.t08,
                  SubjectChips(
                    subjects: state.subjects
                        .map((s) => s.toChipData())
                        .toList(),
                    selectedId: state.materialSubjectId,
                    onSelect: state.selectMaterialSubject,
                    emptyMessage:
                        'No subjects added yet — go back to step 2.',
                  ),
                  Space.y.t16,

                  GestureDetector(
                    onTap: () => state.addFiles(context),
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
                            attachSubject != null
                                ? 'Add files to $attachSubject'
                                : 'Tap to add files',
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
                        onTap: () => state.addFiles(context),
                      ),
                      Space.x.t08,
                      _SourceChip(
                        label: 'Photos',
                        icon: LucideIcons.image,
                        onTap: () => state.addImages(context),
                      ),
                      Space.x.t08,
                      _SourceChip(
                        label: 'Camera',
                        icon: LucideIcons.camera,
                        onTap: () => state.captureImage(context),
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
                  if (state.materials.isEmpty)
                    Text(
                      'Nothing yet — add slides, past papers, or notes above.',
                      style: AppText.b2.cl(AppTheme.c.subText),
                    ),
                  ...state.materials.expand(
                    (item) => [
                      LibraryItemTile(
                        item: item,
                        subjectName: state.subjectNameFor(item.subjectId),
                        trailing: AppTouch(
                          onTap: () => state.removeMaterial(item.id),
                          hasSplash: false,
                          child: Icon(
                            LucideIcons.x,
                            size: 18,
                            color: AppTheme.c.subText,
                          ),
                        ),
                      ),
                      Space.y.t08,
                    ],
                  ),

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
