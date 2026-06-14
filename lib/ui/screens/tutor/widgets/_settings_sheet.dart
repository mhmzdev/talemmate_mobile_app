part of '../tutor.dart';

/// Bottom sheet for the tutor settings that shape grounding + tone. Each change
/// persists immediately via `ChatCubit.saveSettings`.
class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet();

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/tutor-settings'),
    builder: (_) => const _SettingsSheet(),
  );

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late TutorSettings _settings;

  static const _scopeLabels = {
    TutorScope.libraryOnly: 'Library only',
    TutorScope.libraryAndLectures: 'Library + lectures',
  };

  @override
  void initState() {
    super.initState();
    final state = ChatCubit.c(context).state;
    _settings =
        state.settings.data ?? TutorSettings(userId: state.userId ?? '');
  }

  void _update(TutorSettings next) {
    setState(() => _settings = next);
    ChatCubit.c(context).saveSettings(next);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppModalBase(
      dragger: true,
      title: 'Tutor settings',
      subtitle: 'Shape how the tutor grounds and explains its answers.',
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          _label('GROUNDING SCOPE'),
          Space.y.t08,
          Wrap(
            spacing: SpaceToken.t08,
            runSpacing: SpaceToken.t08,
            children: TutorScope.values
                .map(
                  (s) => AppChoiceChip(
                    label: _scopeLabels[s]!,
                    selected: _settings.scope == s,
                    onTap: () => _update(_settings.copyWith(scope: s)),
                  ),
                )
                .toList(),
          ),
          Space.y.t16,
          _label('ANSWER DEPTH'),
          Space.y.t08,
          Wrap(
            spacing: SpaceToken.t08,
            runSpacing: SpaceToken.t08,
            children: ReasoningDepth.values
                .map(
                  (d) => AppChoiceChip(
                    label: d.name.titleCase,
                    selected: _settings.reasoningDepth == d,
                    onTap: () => _update(_settings.copyWith(reasoningDepth: d)),
                  ),
                )
                .toList(),
          ),
          Space.y.t16,
          Row(
            children: [
              Expanded(
                child: Text(
                  'Show citations on every reply',
                  style: AppText.b1.cl(AppTheme.c.text),
                ),
              ),
              Switch(
                value: _settings.showCitationsOnEveryReply,
                activeThumbColor: AppTheme.c.accent,
                onChanged: (v) => _update(
                  _settings.copyWith(showCitationsOnEveryReply: v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: AppText.l1b.cl(AppTheme.c.subText).copyWith(letterSpacing: 1.2),
  );
}
