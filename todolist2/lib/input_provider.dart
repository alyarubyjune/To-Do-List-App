import 'package:flutter/material.dart';

import 'todo_item.dart';

class InputProvider extends ChangeNotifier {
  List<ToDoItem> itemList = [];
  List<ToDoItem> checkedList = [];
  String inputValue = '';
  String? selectedOption = '';
  bool showCheckedItems = false;

  void setInputValue(String? value) {
    if (value != null) {
      inputValue = value;
      notifyListeners();
    }
  }

  void addItem() {
    itemList.add(ToDoItem(title: inputValue));
    notifyListeners();
  }

  void setCheckedStatus(int index, bool isChecked) {
    itemList[index].isChecked = isChecked;
    if (isChecked) {
      checkedList.add(itemList[index]);
      itemList[index].isExpanded = false;
    } else {
      checkedList.remove(itemList[index]);
    }
    notifyListeners();
  }

  void toggleExpansion(int index) {
    itemList[index].isExpanded = !itemList[index].isExpanded;
    notifyListeners();
  }

  void setCheckedItems(bool value) {
    showCheckedItems = value;
    notifyListeners();
  }

  void setFilterOption(String? option) {
    selectedOption = option;
    notifyListeners();
  }
}
