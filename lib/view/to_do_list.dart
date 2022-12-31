import 'package:etiqa_to_do_list/controller/navigator.dart';
import 'package:etiqa_to_do_list/controller/to_do_list_provider.dart';
import 'package:etiqa_to_do_list/services/sqlite_db_handler.dart';
import 'package:etiqa_to_do_list/view/dynamic_widget.dart';
import 'package:etiqa_to_do_list/view/to_do_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key, required this.title});

  final String title;

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late DBHandler handler;

  @override
  void initState() {
    handler = DBHandler();
    handler.initialiseDB().whenComplete(() =>
        Provider.of<ToDoListProvider>(context, listen: false).fetchData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xffffbb00),
        title: Text(widget.title, style: const TextStyle(fontSize: 18.0)),
      ),
      body: Center(child:
          Consumer<ToDoListProvider>(builder: (context, notifier, child) {
        Widget? widget1;
        // Awann - 27 Dec 2022
        // display loading indicator while wait for data to be fetch
        if (notifier.getIsFetching == true) {
          widget1 = const CupertinoActivityIndicator();
        }
        //display message for empty list
        else if (notifier.getIsFetching == false &&
            notifier.getTodoList.isEmpty) {
          widget1 = const Text('There is no to-do list have been added yet.');
        }
        //display to do list
        else if (notifier.getIsFetching == false &&
            notifier.getTodoList.isNotEmpty) {
          var list = notifier.getTodoList;

          debugPrint('to do list length : ${list.length}');

          widget1 = RefreshIndicator(
            onRefresh: () =>
                Provider.of<ToDoListProvider>(context, listen: false)
                    .fetchData(),
            child: ListView.builder(
                itemCount: notifier.getTodoList.length,
                itemBuilder: (context, idx) {
                  //convert date format
                  String dispStartDate = DateFormat("dd MMM yyyy")
                      .format(DateTime.parse(list[idx].startdate.toString()))
                      .toString();
                  String dispEndDate = DateFormat("dd MMM yyyy")
                      .format(DateTime.parse(list[idx].endDate.toString()))
                      .toString();

                  //calculate time left until end of date for task
                  var timeLeft = DateTime.parse(list[idx].endDate.toString())
                      .difference(DateTime.now());

                  String dispStatus = "incomplete";

                  //convert task status stored to status to display format
                  if (list[idx].status.toString().toLowerCase() == 'false') {
                    dispStatus = "Incomplete";
                  } else if (list[idx].status.toString().toLowerCase() ==
                      'true') {
                    dispStatus = "Complete";
                  }

                  return Column(
                    children: <Widget>[
                      if (idx == 0)
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                          child: const Text(
                              'Please swipe to the right to remove the to-do list from list',
                              style: TextStyle(fontSize: 12)),
                        ),
                      Dismissible(
                        key: ValueKey<int>(list[idx].id!),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) async {
                          await Provider.of<ToDoListProvider>(context,
                                  listen: false)
                              .removeToDoList(list[idx].id!, context);
                        },
                        background: Container(
                          color: Colors.transparent,
                          child: const Icon(Icons.delete),
                        ),
                        child: DynamicWidget().toDoListCard(
                          context: context,
                          idx: idx,
                          list: list,
                          dispStartDate: dispStartDate,
                          dispEndDate: dispEndDate,
                          timeLeft: timeLeft,
                          dispStatus: dispStatus,
                          taskComplete: list[idx].status,
                          onTapped: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToDoListDetailsPage(
                                          title: "Add new To-Do List",
                                          toDoId: list[idx].id.toString(),
                                          toDoTitle: list[idx].title,
                                          dateStart: dispStartDate,
                                          dateStart1: DateTime.parse(
                                              list[idx].startdate.toString()),
                                          dateEnd: dispEndDate,
                                          dateEnd1: DateTime.parse(
                                              list[idx].endDate.toString()),
                                        )));
                          },
                        ),
                      )
                    ],
                  );
                }),
          );
        }
        //display empty screen if all if statement not met
        else {
          widget1 = const SizedBox(height: 20);
        }

        return widget1;
      })),
      //Awann - 26 Dec 2022
      //add to do list button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFf0744f),
        onPressed: () => ToDoListNavigator()
            .navigateTo(path: "/toDoDetails", context: context),
        tooltip: 'Add To-Do List',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
