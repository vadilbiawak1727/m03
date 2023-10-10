import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider {
  static const String _historyKey = 'deletion_history';

  static Future<List<Map<String, dynamic>>> getDeletionHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList(_historyKey);
    return history?.map((item) {
      List<String> parts = item.split('|');
      return {
        'timestamp': parts[1], // Ubah dari parts[0] ke parts[1]
        'description': parts[0],
      };
    }).toList() ?? [];
  }

  static Future<void> addDeletionToHistory(Map<String, dynamic> shoppingList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList(_historyKey);
    history ??= []; 
    String description = 'id: ${shoppingList['id']}, name: ${shoppingList['name']}, sum: ${shoppingList['sum']}';

    DateTime now = DateTime.now();
    String timestamp = now.toLocal().toString();
    history.add('$description|$timestamp');
    await prefs.setStringList(_historyKey, history);
  }
}
