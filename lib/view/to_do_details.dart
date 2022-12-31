import 'package:etiqa_to_do_list/controller/to_do_list_provider.dart';
import 'package:etiqa_to_do_list/view/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ToDoListDetailsPage extends StatefulWidget {
  const ToDoListDetailsPage(
      {super.key,
      required this.title,
      this.toDoId,
      this.toDoTitle,
      this.dateStart,
      this.dateEnd,
      required this.dateStart1,
      required this.dateEnd1});

  final String title;
  final String? toDoId;
  final String? toDoTitle;
  final String? dateStart;
  final String? dateEnd;
  final DateTime dateStart1;
  final DateTime dateEnd1;

  @override
  State<ToDoListDetailsPage> createState() => _ToDoListDetailsPageState();
}

class _ToDoListDetailsPageState extends State<ToDoListDetailsPage> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //Awann - 27 Dec 2022
    //init assign value to text controller if passing data not empty
    if (widget.toDoTitle != null && widget.toDoTitle != "") {
      titleCtrl.text = widget.toDoTitle ?? "";
    }
    if (widget.dateStart != null && widget.dateStart != "") {
      startDateCtrl.text = widget.dateStart ?? "";
    }
    if (widget.dateEnd != null && widget.dateEnd != "") {
      endDateCtrl.text = widget.dateEnd ?? "";
    }
    startDate = widget.dateStart1;
    endDate = widget.dateEnd1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width / 20,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 30,
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: const Color(0xffffbb00),
        title: Text(widget.title, style: const TextStyle(fontSize: 18.0)),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 60, 20, 60),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //Awann - 27 Dec 2022
                  //email textfield
                  DynamicWidget().inputBox(
                      label: "To-Do Title",
                      context: context,
                      maxLines: 5,
                      minLines: 5,
                      validator: validateEmptyField,
                      controller: titleCtrl,
                      hintTxt: "Please key in your To-Do title here."),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  //date start textfield
                  DynamicWidget().inputBox(
                      label: "Start Date",
                      onlyRead: true,
                      context: context,
                      validator: validateEmptyField,
                      controller: startDateCtrl,
                      hintTxt: "Please select start date.",
                      tapped: () {
                        selectDate(startDateCtrl, 0);
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  //date end textfield
                  DynamicWidget().inputBox(
                      label: "Estimated End Date",
                      onlyRead: true,
                      context: context,
                      validator: validateEmptyField,
                      controller: endDateCtrl,
                      hintTxt: "Please select end date.",
                      tapped: () {
                        selectDate(endDateCtrl, 1);
                      }),
                ],
              )),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black))),
            backgroundColor: const MaterialStatePropertyAll(Colors.black),
          ),
          // onPressed: () => ToDoListAction().add(context),
          onPressed: () => checkFormFields(),
          child: Text(widget.toDoTitle != null
              ? "Update"
              : "Create Now"), //change to Update string if to do list title is not empty
        ),
      ),
    );
  }

  //empty field validator
  String? validateEmptyField(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty.';
    } else {
      return null;
    }
  }

  //Awann - 27 Dec 2022
  //select date function
  Future<Function?> selectDate(
      TextEditingController? dateCtrl, int? dateType) async {
    DateTime initDate = DateTime.now();
    if (dateType == 1) {
      initDate = endDate;
    } else if (dateType == 0) {
      initDate = startDate;
    }

    debugPrint('select date');
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: dateType == 0 ? initDate : startDate,
        // avoid user from select end date before start date
        firstDate: dateType == 0 ? DateTime(DateTime.now().year) : startDate,
        lastDate: DateTime(2200));

    if (dateType == 1) {
      setState(() {
        endDate = newDate ?? endDate;
      });
    } else if (dateType == 0) {
      setState(() {
        startDate = newDate ?? startDate;
      });
    }

    //formatting date to display
    String dispDate =
        DateFormat("dd MMMM yyyy").format(newDate ?? initDate).toString();
    dateCtrl?.text = dispDate;

    return null;
  }

  //Awann - 31 Dec 2022
  //submit update / update request
  checkFormFields() {
    if (_formKey.currentState!.validate()) {
      debugPrint('all field filled');

      debugPrint('to-do list title pass : ${widget.toDoTitle}');

      //update task list
      if (widget.toDoTitle != null) {
        Map<String, String> toDoList = {
          "id": widget.toDoId!,
          "title": titleCtrl.text,
          "start_date": startDate.toString(),
          "end_date": endDate.toString(),
          "status_complete": false.toString()
        };

        debugPrint('to-do list: $toDoList');

        Provider.of<ToDoListProvider>(context, listen: false)
            .updateToDoList(toDoList, context);
      }
      //add task list
      else {
        Map<String, String> toDoList = {
          "title": titleCtrl.text,
          "start_date": startDate.toString(),
          "end_date": endDate.toString(),
          "status_complete": false.toString()
        };

        debugPrint('to-do list: $toDoList');

        Provider.of<ToDoListProvider>(context, listen: false)
            .addToDoList(toDoList, context);
      }
    }
  }
}
