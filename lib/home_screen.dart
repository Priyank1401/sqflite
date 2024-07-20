import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite/add_new_dialog.dart';
import 'package:sqlite/db/my_database.dart';
import 'package:sqlite/filter_dialog.dart';
import 'package:sqlite/model/task_model.dart';
import 'package:sqlite/utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MyDatabase myDatabase = MyDatabase.instance;
  List<TaskModel> taskList = [];
  String selectedMonth = DateFormat.MMMM().format(DateTime.now());
  double total = 0.0;

  @override
  void initState() {
    filterTasks(DateFormat.MMMM().format(DateTime.now()), '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('SQLite'),
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => FilterDialog(),
                ).then((value) {
                  if(value != null) {
                    Map<String, String> data = value;
                    setState(() {
                      selectedMonth = data['month'].toString();
                    });
                    filterTasks(selectedMonth, data['title'].toString());
                  }
                });
              },
              icon: const Icon(Icons.filter_alt_outlined),
            ),
          ]
      ),
      body: taskList.isEmpty ? const Center(
        child: Text('Not Found')) : Container(
        padding: const EdgeInsets.all(10.0),
          child: Table(
              border: TableBorder.all(width: 1.0, color: Colors.black),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Date', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Title', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Weight\nPrice', style: Theme.of(context).textTheme.titleMedium),
                      ),
                ]),
                for (var item in taskList) TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.date.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  InkWell(
                    onLongPress: () {
                      Utils.showDialogAlert(context, AlertDialog(
                        title: const Text('Delete'),
                        content: const Text('Are you sure to want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await myDatabase.delete(item.id!);
                              filterTasks(selectedMonth, '');
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.quantity),
                          Text('₹${item.price}', style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ),
                  ),
                ])
              ]
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Utils.showDialogAlert(context, const AddNewDialog());
          await showDialog(
              context: context,
              builder: (BuildContext context) => AddNewDialog()
          ).then((value) {
            filterTasks(DateFormat.MMMM().format(DateTime.now()), '');
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedMonth, style: TextStyle(color: Colors.white, fontSize: 18)),
            Text('₹ $total', style: TextStyle(color: Colors.white, fontSize: 18))
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    myDatabase.close();
    super.dispose();
  }

  Future<void> filterTasks(String month, String title) async {
    await myDatabase.filterTasks(month, title).then((value) {
      setState(() {
        taskList = value;
        total = 0.0;
        for (int i = 0; i < taskList.length; i++) {
          total = total + taskList[i].price;
        }
      });
    });
  }
}
