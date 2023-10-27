import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'input_provider.dart';
import 'todo_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _menuKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  void _openDrawer() {
    _menuKey.currentState!.openDrawer();
  }

  void _showInputPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final inputProvider =
            Provider.of<InputProvider>(context, listen: false);

        return AlertDialog(
          title: const Text('Input Popup'),
          content: TextField(
            onChanged: (inputValue) {
              inputProvider.setInputValue(inputValue);
            },
            decoration: const InputDecoration(
              hintText: 'Enter a value',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                inputProvider.addItem();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckedItems(BuildContext context, bool value) {
    final inputProvider = Provider.of<InputProvider>(context, listen: false);
    inputProvider.setCheckedItems(value);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final inputProvider =
                  Provider.of<InputProvider>(context, listen: false);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Checked'),
                    leading: Radio(
                      value: 'Checked',
                      groupValue: inputProvider.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          inputProvider.setFilterOption(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Unchecked'),
                    leading: Radio(
                      value: 'Unchecked',
                      groupValue: inputProvider.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          inputProvider.setFilterOption(value);
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    final itemList = inputProvider.itemList
        .where((item) => item.isChecked == inputProvider.showCheckedItems)
        .toList();

    return Scaffold(
      key: _menuKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
              ),
              pinned: true,
              floating: true,
              expandedHeight: 20.0,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                padding: const EdgeInsets.only(left: 20.0),
                onPressed: _openDrawer,
              ),
              flexibleSpace: const FlexibleSpaceBar(
                title: Center(
                  child: Text(
                    'To Do List App',
                    style: TextStyle(
                      color: Color.fromRGBO(202, 67, 76, 0),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.filter),
                  padding: const EdgeInsets.only(right: 20.0),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final inputProvider = Provider.of<InputProvider>(context);

                  return ExpansionPanelList(
                    elevation: 2,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) {
                      inputProvider.toggleExpansion(index);
                    },
                    children: itemList.map<ExpansionPanel>((ToDoItem item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(244, 130, 65, 0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: const Text(
                                'Additional details or description',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              leading: Checkbox(
                                value: item.isChecked,
                                onChanged: (value) {
                                  inputProvider.setCheckedStatus(
                                      index, value ?? false);
                                },
                              ),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Text(item.title),
                          subtitle:
                              const Text('Additional details or description'),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputPopup(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
