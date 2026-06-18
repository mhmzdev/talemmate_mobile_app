part of 'profile.dart';

/// Ephemeral profile-screen state. Toggles are local-only for now — no
/// persistence is wired yet (settings backend is a future feature). The one
/// real action is [confirmSignOut], which tears down the session.
class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  // AI tutor
  bool citations = true;

  // Notifications
  bool blockReminders = true;
  bool dailyCheckin = true;
  bool examCountdown = true;

  bool duaCard = true;
  bool hijri = true;

  // Language
  bool urduRendering = false;

  // Privacy & data
  bool cloudBackup = false;

  void toggleCitations(bool v) => _set(() => citations = v);
  void toggleBlockReminders(bool v) => _set(() => blockReminders = v);
  void toggleDailyCheckin(bool v) => _set(() => dailyCheckin = v);
  void toggleExamCountdown(bool v) => _set(() => examCountdown = v);
  void toggleDuaCard(bool v) => _set(() => duaCard = v);
  void toggleHijri(bool v) => _set(() => hijri = v);
  void toggleUrduRendering(bool v) => _set(() => urduRendering = v);
  void toggleCloudBackup(bool v) => _set(() => cloudBackup = v);

  void _set(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// Confirms before tearing down the session, then signs out.
  void confirmSignOut(BuildContext context) {
    showAppAlert(
      context,
      icon: const Icon(LucideIcons.log_out),
      title: 'Sign out of TaleemMate?',
      subtitle:
          'Your study material and progress stay saved on this device. '
          'You can sign back in anytime.',
      actions: [
        AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
        AppAlertAction(
          label: 'Sign out',
          isDestructive: true,
          onTap: () => _signOut(context),
        ),
      ],
      routeName: 'confirm-sign-out',
    );
  }

  /// Dispatches the logout action only. Navigation away from the screen is a
  /// side effect of the `UserState.logout` transition and is handled by
  /// [_LogoutListener] — this layer never navigates as a result of state.
  void _signOut(BuildContext context) {
    Navigator.pop(context); // dismiss the alert
    UserCubit.c(context).logout();
  }
}
