// Hide Flutter's MaterialState — this screen references our MaterialCubit's
// MaterialState (background text-extraction) in a BlocListener type argument.
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/material/cubit.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/services/material_picker/material_picker.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/design/alerts/app_alert_base.dart';
import 'package:taleemmate/ui/widgets/design/library/library_item_tile.dart';
import 'package:taleemmate/ui/widgets/design/library/subject_chips.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_choice_chip.dart';
import 'package:taleemmate/ui/widgets/design/modals/app_modal_base.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';

part 'static/_form_data.dart';
part 'static/_form_keys.dart';

part '_state.dart';
part 'widgets/_material_status.dart';

part 'utils.dart';
part 'widgets/_header.dart';
part 'widgets/_search_bar.dart';
part 'widgets/_filter_chips.dart';
part 'widgets/_subject_section.dart';
part 'widgets/_add_material_tile.dart';
part 'widgets/_add_material_sheet.dart';
part 'widgets/_material_actions_sheet.dart';
part 'widgets/_library_skeleton.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();
    // Load once on mount (splash precedent). The cubit no-ops if no session uid.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) LibraryCubit.c(context).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context, true);

    return Screen(
      formKey: screenState.formKey,
      initialFormValue: _FormData.initialValues(),
      keyboardHandler: true,
      floatingActionButton: AppButton(
        icon: LucideIcons.plus,
        size: .large,
        padding: Space.a.t20,
        margin: Space.b.t60 + Space.b.t12,
        onTap: () => _AddMaterialSheet.show(context),
      ),
      child: SafeArea(
        // Extraction runs in the background via MaterialCubit; re-read the list
        // whenever an item's processing settles so its status badge updates.
        child: BlocListener<MaterialCubit, MaterialState>(
          // Compare the whole BlocState, not just `action` — concurrent items
          // share this single state, so two items settling on the same action
          // (e.g. failed→failed) must still trigger a re-read (meta/fault differ).
          listenWhen: (a, b) => a.process != b.process,
          listener: (context, _) => LibraryCubit.c(context).load(),
          child: BlocConsumer<LibraryCubit, LibraryState>(
            listenWhen: (a, b) =>
                a.load.action != b.load.action ||
                a.add.action != b.add.action ||
                a.remove.action != b.remove.action,
            listener: (context, state) {
              if (state.load.isFailed) {
                UIFlash.error(context, state.load.errorMessage);
              }
              if (state.add.isFailed) {
                UIFlash.error(context, state.add.errorMessage);
              }
              if (state.remove.isFailed) {
                UIFlash.error(context, state.remove.errorMessage);
              }
            },
            builder: (context, state) {
              final items = state.load.data ?? const <LibraryItem>[];

              // First load (nothing cached yet) → full-screen skeleton.
              if (state.load.isLoading && items.isEmpty) {
                return const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: _LibrarySkeleton(),
                );
              }

              final totalSize = items.fold<int>(
                0,
                (sum, i) => sum + i.fileSize,
              );
              final sections = groupMaterials(
                items: items,
                subjects: state.subjects,
                query: screenState.searchQuery,
                subjectFilter: screenState.activeSubjectFilter,
              );

              return RefreshIndicator(
                onRefresh: () => LibraryCubit.c(context).load(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      _Header(count: items.length, totalSize: totalSize),
                      Padding(
                        padding: Space.sym(SpaceToken.t24, SpaceToken.t04),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          children: [
                            const _SearchBar(),
                            Space.y.t12,
                            _FilterChips(
                              subjects: state.subjects,
                              selectedId: screenState.activeSubjectFilter,
                            ),
                            _Content(state: state, sections: sections),
                            Space.y.t16,
                            const _AddMaterialTile(),
                            Space.y.t12,
                            Text(
                              'New uploads are processed privately on your device '
                              'for OCR & embeddings.',
                              style: AppText.b2.cl(AppTheme.c.subText),
                              textAlign: .center,
                            ),
                            Space.y.t24,
                          ],
                        ),
                      ),
                      Space.y.t100,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Switches between loader / error+retry / empty / "no matches" / the grouped
/// sections based on the load state and the derived [sections].
class _Content extends StatelessWidget {
  const _Content({required this.state, required this.sections});

  final LibraryState state;
  final List<LibrarySection> sections;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final items = state.load.data ?? const <LibraryItem>[];

    if (state.load.isFailed && items.isEmpty) {
      return Padding(
        padding: Space.v.t32,
        child: Column(
          children: [
            Text(
              state.load.errorMessage,
              style: AppText.b2.cl(AppTheme.c.subText),
              textAlign: .center,
            ),
            Space.y.t12,
            AppButton(
              label: 'Retry',
              onTap: () => LibraryCubit.c(context).load(),
            ),
          ],
        ),
      );
    }

    if (sections.isEmpty) {
      final message = items.isEmpty
          ? 'No materials yet — add from onboarding or the button below.'
          : 'No materials match your search.';
      return Padding(
        padding: Space.v.t32,
        child: Text(
          message,
          style: AppText.b2.cl(AppTheme.c.subText),
          textAlign: .center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: sections.map((s) => _SubjectSection(section: s)).toList(),
    );
  }
}
