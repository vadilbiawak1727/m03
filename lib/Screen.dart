import 'dart:math';
import 'package:flutter/material.dart';
import 'package:m03/HistoryScreen.dart';
import 'package:m03/ItemScreen.dart';
import 'package:m03/List_dialog.dart';
import 'package:m03/MyProvider.dart';
import 'package:m03/ShoppingList.dart';
import 'package:m03/dbhelper.dart';
import 'package:m03/HistoryProvider.dart';
// import 'package:my_sql_db/Praktek/ItemsScreen.dart';
// import 'package:my_sql_db/Praktek/model/ShoppingList.dart';
// import 'package:my_sql_db/Praktek/util/shopping_list_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'Provider/myProvider.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int id = 0;
  DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadLastId();
  }

  Future<void> _loadLastId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('lastId') ?? 0;
    });
  }

  Future<void> _saveLastId(int lastId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastId', lastId);
  }

  Future<void> _deleteAllShoppingList() async {
    await _dbHelper.deleteAllShoppingList();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Shopping lists deleted"),
    ));
    List<ShoppingList> shoppingList =
        Provider.of<ListProductProvider>(context, listen: false)
            .getShoppingList;
    for (var item in shoppingList) {
      await HistoryProvider.addDeletionToHistory(item.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getmyShoppingList().then((value) => tmp.setShoppingList = value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        backgroundColor: const Color.fromARGB(255, 105, 139, 96),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete All',
            onPressed: () {
              _deleteAllShoppingList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount:
              tmp.getShoppingList != null ? tmp.getShoppingList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(tmp.getShoppingList[index].id.toString()),
                onDismissed: (direction) {
                  String tmpName = tmp.getShoppingList[index].name;
                  int tempId = tmp.getShoppingList[index].id;
                  setState(() {
                    tmp.deleteById(tmp.getShoppingList[index]);
                  });
                  _dbHelper.deleteShoppingList(tempId);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$tmpName Delete"),
                  ));
                },
                child: ListTile(
                  title: Text(tmp.getShoppingList[index].name),
                  leading: CircleAvatar(
                    child: Text("${tmp.getShoppingList[index].sum}"),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ItemScreen(tmp.getShoppingList[index]);
                    }));
                  },
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ShoppingListDialog(_dbHelper).buildDialog(
                                  context, tmp.getShoppingList[index], false);
                            });
                        _dbHelper
                            .getmyShoppingList()
                            .then((value) => tmp.setShoppingList = value);
                      }),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return ShoppingListDialog(_dbHelper)
                    .buildDialog(context, ShoppingList(++id, "", 0), true);
              });
          await _saveLastId(id); // Simpan ID terakhir
          _dbHelper
              .getmyShoppingList()
              .then((value) => tmp.setShoppingList = value);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _dbHelper.closeDB();
    super.dispose();
  }
}
