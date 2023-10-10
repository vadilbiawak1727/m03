import 'package:flutter/material.dart';
import 'package:m03/ShoppingList.dart';
// import 'package:my_sql_db/Praktek/model/ShoppingList.dart';

class ListProductProvider extends ChangeNotifier{
  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get getShoppingList => _shoppingList;
  set setShoppingList(Value) {
    _shoppingList = Value;
    notifyListeners();
  }

  void deleteById(ShoppingList) {
    _shoppingList.remove(ShoppingList);
    notifyListeners();
  }
  
  void clearShoppingList() {
    _shoppingList.clear();
    notifyListeners();
  }
}