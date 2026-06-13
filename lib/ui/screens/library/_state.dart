part of 'library.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();

  /// In-memory search query — filters the visible list by name (no DB query).
  String searchQuery = '';

  /// Active subject filter; `null` means "All".
  String? activeSubjectFilter;

  void setQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void setFilter(String? subjectId) {
    activeSubjectFilter = subjectId;
    notifyListeners();
  }
}
