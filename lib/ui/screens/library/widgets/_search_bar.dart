part of '../library.dart';

/// In-state search field — every keystroke updates `_ScreenState.searchQuery`,
/// which re-derives the grouped list in memory (no DB query).
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context);

    return AppFormTextInput(
      name: _FormKeys.search,
      placeholder: 'Search notes, slides, photos…',
      prefixIcon: LucideIcons.search,
      textInputAction: .search,
      onChanged: (v) => state.setQuery(v ?? ''),
    );
  }
}
