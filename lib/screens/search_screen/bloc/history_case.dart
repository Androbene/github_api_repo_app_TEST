import '../../../main.dart';

class SearchHistoryCase {
  final _key = "search_history_key";

  SearchHistoryCase();

  List<String> load() => prefs.getStringList(_key) ?? [];

  void save(String searchString) {
    if (searchString.trim().isEmpty) return;
    final savedHistory = load();
    savedHistory.add(searchString.trim());
    prefs.setStringList(_key, savedHistory);
  }
}
