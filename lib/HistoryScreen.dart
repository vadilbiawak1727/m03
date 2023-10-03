import 'package:flutter/material.dart';
import 'HistoryProvider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deletion History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: HistoryProvider.getDeletionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Description: id: ${historyList[index]['id']}, name: ${historyList[index]['name']}, sum: ${historyList[index]['sum']}'),
                  subtitle: Text('Time: ${historyList[index]['timestamp']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
