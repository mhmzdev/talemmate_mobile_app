part of '../profile.dart';

/// Bottom sheet for editing the user's institution. Dispatches the save to
/// [UserCubit.updateProfile]; the pop + flash are state-driven via a
/// [BlocConsumer] that the *sheet itself* owns — so a slow (e.g. offline-queued)
/// write that only succeeds after the sheet is dismissed can't pop an unrelated
/// route.
class _InstitutionSheet extends StatefulWidget {
  const _InstitutionSheet({this.initial});

  final String? initial;

  /// Opens the "edit institution" sheet, seeded with the current value.
  static Future<void> show(BuildContext context, String? initial) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/edit-institution'),
      builder: (_) => _InstitutionSheet(initial: initial),
    );
  }

  @override
  State<_InstitutionSheet> createState() => _InstitutionSheetState();
}

class _InstitutionSheetState extends State<_InstitutionSheet> {
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.initial ?? '',
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final saving = UserCubit.c(context).state.update.isLoading;
    if (saving) return;
    UserCubit.c(context).updateProfile({'institution': _ctrl.text.trim()});
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (a, b) => a.update != b.update,
      listener: (context, state) {
        if (state.update.isFailed) {
          UIFlash.error(context, state.update.errorMessage);
        }
        if (state.update.isSuccess) {
          UIFlash.success(context, 'Institution updated');
          Navigator.pop(context); // closes this sheet (its own route)
        }
      },
      builder: (context, state) {
        final saving = state.update.isLoading;
        return AppModalBase(
          dragger: true,
          title: 'Institution',
          subtitle: 'Where you study, so your tutor can talk in context.',
          actions: [
            AppButton(
              label: saving ? 'Saving…' : 'Save',
              mainAxisSize: .max,
              state: saving ? .disabled : .def,
              onTap: _save,
            ),
            AppButton(
              label: 'Cancel',
              style: .creamy,
              mainAxisSize: .max,
              onTap: () => Navigator.pop(context),
            ),
          ],
          child: FormBuilder(
            child: AppFormTextInput(
              name: 'institution',
              controller: _ctrl,
              disposeController: false,
              placeholder: 'Search or type your institution',
              textCapitalization: .words,
              autofocus: true,
              onFieldSubmitted: (_) => _save(),
            ),
          ),
        );
      },
    );
  }
}
