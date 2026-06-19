part of '../profile.dart';

/// A titled group of setting rows inside a bordered card. [aside] renders at
/// the far end of the eyebrow (e.g. the AI pill).
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.aside});

  final String title;
  final List<Widget> children;
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Padding(
      padding: Space.only(SpaceToken.t24, SpaceToken.t24, null, SpaceToken.t24),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: Space.only(null, null, SpaceToken.t08, SpaceToken.t04),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppText.l1b
                      .cl(AppTheme.c.subText)
                      .gm()
                      .copyWith(letterSpacing: 1.5),
                ),
                ?aside,
              ],
            ),
          ),
          Container(
            padding: Space.h.t16,
            decoration: BoxDecoration(
              color: AppTheme.c.specBackground,
              borderRadius: 14.radius(),
              border: Border.all(color: AppTheme.c.border),
            ),
            child: Column(crossAxisAlignment: .stretch, children: children),
          ),
        ],
      ),
    );
  }
}

/// The "Account" group — reads live session data (subjects, schedule, materials,
/// institution) from the app-level cubits rather than placeholder copy. "Material"
/// jumps to the Library; the editor-backed rows are wired as that feature lands.
class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final lib = LibraryCubit.c(context, true).state;
    final schedule = PlanCubit.c(context, true).state.schedule;
    final institution = UserCubit.c(context, true).state.userData?.institution;

    final subjects = lib.subjects.length;
    final items = lib.load.data ?? const [];
    final totalSize = items.fold<int>(0, (sum, it) => sum + it.fileSize);
    final hrs = schedule?.dailyTargetHours;

    return _Section(
      title: 'Account',
      children: [
        _SettingRow(
          icon: LucideIcons.book_open,
          label: 'Subjects & confidence',
          value: subjects == 1 ? '1 subject' : '$subjects subjects',
        ),
        _SettingRow(
          icon: LucideIcons.calendar,
          label: 'Schedule & exams',
          value: hrs == null ? 'Not set' : '${hrs.toStringAsFixed(1)} hrs/day',
        ),
        _SettingRow(
          icon: LucideIcons.library,
          label: 'Material',
          value:
              '${items.length} item${items.length == 1 ? '' : 's'} · ${totalSize.readableSize}',
          onTap: () => AppRoutes.library.pushReplace(context),
        ),
        _SettingRow(
          icon: LucideIcons.flag,
          label: 'Institution',
          value: (institution == null || institution.isEmpty)
              ? 'Add'
              : institution,
          last: true,
        ),
      ],
    );
  }
}

/// Hairline divider drawn under a row unless it is the last in its section.
BoxDecoration? _rowDivider(bool last) => last
    ? null
    : BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.c.border)),
      );

/// A leading icon slot of fixed width so labels align with iconless rows.
class _IconSlot extends StatelessWidget {
  const _IconSlot({this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return SizedBox(
      width: SpaceToken.t24,
      child: icon == null
          ? null
          : Icon(icon, size: SpaceToken.t20, color: AppTheme.c.subText),
    );
  }
}

/// A tappable settings row: icon + label, optional trailing value + chevron.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.icon,
    this.value,
    this.valueTone,
    // ignore: unused_element_parameter — reserved for future row navigation
    this.onTap,
    this.last = false,
  });

  final IconData? icon;
  final String label;
  final String? value;
  final Color? valueTone;
  final VoidCallback? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      behavior: .opaque,
      onTap: onTap,
      child: Container(
        decoration: _rowDivider(last),
        padding: Space.v.t12,
        child: Row(
          children: [
            _IconSlot(icon: icon),
            Space.x.t12,
            Expanded(child: Text(label, style: AppText.b1.w(5))),
            if (value != null)
              Text(
                value!,
                style: AppText.b2.cl(valueTone ?? AppTheme.c.subText),
              ),
            Space.x.t08,
            Icon(
              LucideIcons.chevron_right,
              size: SpaceToken.t16,
              color: AppTheme.c.subText.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// A settings row with a trailing [_AppSwitch] and optional sub-label.
class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.sub,
    this.trailing,
    this.last = false,
  });

  final IconData? icon;
  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? trailing;
  final bool last;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Container(
      decoration: _rowDivider(last),
      padding: Space.v.t12,
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: Space.t.t04,
            child: _IconSlot(icon: icon),
          ),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(label, style: AppText.b1.w(5))),
                    if (trailing != null) ...[Space.x.t08, trailing!],
                  ],
                ),
                if (sub != null) ...[
                  Space.y.t04,
                  Text(sub!, style: AppText.b2.cl(AppTheme.c.subText)),
                ],
              ],
            ),
          ),
          Space.x.t12,
          Padding(
            padding: Space.t.t04,
            child: _AppSwitch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

/// Compact toggle switch — ink track when on, knob slides with a short ease.
class _AppSwitch extends StatelessWidget {
  const _AppSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppProps.medium,
        width: 38,
        height: 22,
        padding: const EdgeInsets.all(2), // knob inset (component geometry)
        decoration: BoxDecoration(
          color: value
              ? AppTheme.c.primary
              : AppTheme.c.subText.withValues(alpha: 0.25),
          borderRadius: 999.radius(),
        ),
        child: AnimatedAlign(
          duration: AppProps.medium,
          alignment: value ? .centerRight : .centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.onPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.c.primary.withValues(alpha: 0.18),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Appearance "Theme" row with an auto/light/dark segmented control.
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final appState = AppProvider.s(context, true);

    return Container(
      decoration: _rowDivider(false),
      padding: Space.v.t12,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              const _IconSlot(icon: LucideIcons.sun_medium),
              Space.x.t12,
              Text('Theme', style: AppText.b1.w(5)),
            ],
          ),
          Space.y.t08,
          Container(
            padding: Space.a.t04,
            decoration: BoxDecoration(
              color: AppTheme.isDark
                  ? AppTheme.c.primary
                  : AppTheme.c.subBackground,
              borderRadius: 10.radius(),
            ),
            child: Row(
              children: ThemeMode.values
                  .map(
                    (t) => Expanded(
                      child: _ThemeSegment(
                        label: t.name.titleCase,
                        selected: appState.themeMode == t,
                        onTap: () {
                          appState.setTheme(t);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSegment extends StatelessWidget {
  const _ThemeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppProps.fast,
        padding: Space.v.t08,
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.specBackground : Colors.transparent,
          borderRadius: 8.radius(),
        ),
        child: Text(
          '${label[0].toUpperCase()}${label.substring(1)}',
          textAlign: .center,
          style: AppText.b2
              .w(5)
              .cl(selected ? AppTheme.c.text : AppTheme.c.subText),
        ),
      ),
    );
  }
}
