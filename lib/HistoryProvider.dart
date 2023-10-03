import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider {
  static const String _historyKey = 'deletion_history';

  static Future<List<Map<String, dynamic>>> getDeletionHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList(_historyKey);
    return history?.map((item) {
      List<String> parts = item.split('|');
      return {
        'timestamp': parts[0],
        'description': parts[0],
      };
    }).toList() ?? [];
  }

static Future<void> addDeletionToHistory(Map<String, dynamic> shoppingList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? history = prefs.getStringList(_historyKey);
  history ??= [];
  DateTime now = DateTime.now();
  String timestamp = now.toLocal().toString();
  history.add('$timestamp|$shoppingList');
  await prefs.setStringList(_historyKey, history);
}

}
