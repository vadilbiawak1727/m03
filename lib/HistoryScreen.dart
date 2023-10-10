import 'package:flutter/material.dart';
import 'package:m03/HistoryProvider.dart';
import 'package:intl/intl.dart';

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
                DateTime timestamp =
                    DateTime.parse(historyList[index]['timestamp']);
                String formattedTime =
                    DateFormat.yMMMd().add_jm().format(timestamp);

                return ListTile(
                  title:
                      Text('Description: ${historyList[index]['description']}'),
                  subtitle: Text('Time: $formattedTime'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
