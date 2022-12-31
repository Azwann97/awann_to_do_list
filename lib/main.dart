import 'package:etiqa_to_do_list/controller/to_do_list_provider.dart';
import 'package:etiqa_to_do_list/view/to_do_details.dart';
import 'package:etiqa_to_do_list/view/to_do_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        // Awann - 27 Dec 2022
        // init provider
        providers: [
          ChangeNotifierProvider<ToDoListProvider>(
            create: (context) => ToDoListProvider(),
          )
        ],
        child: MaterialApp(
          // Awann - 26 Dec 2022
          // init page routes
          routes: {
            '/': (context) => const ToDoListPage(title: "To-Do List"),
            '/toDoDetails': (context) => ToDoListDetailsPage(
                title: "Add new To-Do List",
                dateStart1: DateTime.now(),
                dateEnd1: DateTime.now())
          },
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
        ));
  }
}
