import 'package:etiqa_to_do_list/controller/navigator.dart';
import 'package:etiqa_to_do_list/model/to_do_list.dart';
import 'package:etiqa_to_do_list/services/sqlite_db_handler.dart';
import 'package:flutter/cupertino.dart';

class ToDoListProvider extends ChangeNotifier {
  bool isFetching = false;

  bool get getIsFetching => isFetching;

  List<ToDoList> toDoList = [];

  List<ToDoList> get getTodoList => toDoList;

  //Awann - 27 Dec 2022
  //fetch to do list
  fetchData() async {
    isFetching = true;
    notifyListeners();

    try {
      toDoList = await DBHandler().retrieveToDoList();

      debugPrint('to do list from db length : ${toDoList.length}');
    } catch (e) {
      debugPrint('fetch to do list error : $e');
    }

    isFetching = false;
    notifyListeners();
  }

  //Awann - 31 Dec 2022
  //add to do list fuction
  addToDoList(Map<String, String> newToDoList, BuildContext context) async {
    debugPrint('add to do list!');
    ToDoList newToDo = ToDoList();

    try {
      newToDo = ToDoList(
          title: newToDoList['title'],
          status: newToDoList['status_complete'],
          startdate: newToDoList['start_date'],
          endDate: newToDoList['end_date']);

      await DBHandler().insertToDoList(newToDo);
    } catch (e) {
      debugPrint('add to do list error : $e');
    }

    notifyListeners();
    fetchData();
    debugPrint('total stored list: $toDoList');

    ToDoListNavigator().navigateTo(path: "/", context: context);
  }

  //remove to do list fuction
  removeToDoList(int id, BuildContext context) async {
    debugPrint('remove to do list!');

    try {
      await DBHandler().removeToDoList(id);
    } catch (e) {
      debugPrint('remove to do list error : $e');
    }

    notifyListeners();
    fetchData();
    debugPrint('total stored list: $toDoList');

    ToDoListNavigator().navigateTo(path: "/", context: context);
  }

  //update to do list fuction
  updateToDoList(Map<String, String> newToDoList, BuildContext context) async {
    debugPrint('update to do list!');
    ToDoList updatedToDoList = ToDoList();

    try {
      updatedToDoList = ToDoList(
          id: int.parse(newToDoList['id']!),
          title: newToDoList['title'],
          status: newToDoList['status_complete'],
          startdate: newToDoList['start_date'],
          endDate: newToDoList['end_date']);
      await DBHandler().updateToDoList(updatedToDoList);
    } catch (e) {
      debugPrint('update to do list error : $e');
    }

    notifyListeners();
    fetchData();
    debugPrint('total stored list: $toDoList');

    ToDoListNavigator().navigateTo(path: "/", context: context);
  }
}
