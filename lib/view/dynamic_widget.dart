import 'package:etiqa_to_do_list/controller/to_do_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicWidget {
  //Awann - 27 Dec 2022
  //global custom input box
  Widget inputBox(
      {required BuildContext context,
      int? maxLines,
      int? minLines,
      TextEditingController? controller,
      String? Function(String?)? validator,
      String? hintTxt,
      Function()? tapped,
      bool? enabled,
      bool? onlyRead,
      required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0)),
        SizedBox(height: MediaQuery.of(context).size.height / 80),
        TextFormField(
          readOnly: onlyRead ?? false,
          enabled: enabled ?? true,
          onTap: tapped,
          style: const TextStyle(fontSize: 12.0),
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              hintText: hintTxt),
        )
      ],
    );
  }

  //Awann - 27 Dec 2022
  //global custom todolist card
  Widget toDoListCard(
      {required BuildContext context,
      int? idx,
      list,
      dispStartDate,
      dispEndDate,
      timeLeft,
      dispStatus,
      onTapped,
      taskComplete,
      onCheckBoxTick}) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, idx == 0 ? 20.0 : 0.0, 20.0, 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list[idx].title,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Date',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 300),
                          Text(dispStartDate,
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End Date',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 300),
                          Text(dispEndDate,
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Time Left',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 300),
                          Text(
                              '${timeLeft.inHours} hrs ${timeLeft.inMinutes - (timeLeft.inHours * 60)} min',
                              style: const TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: const BoxDecoration(
                  color: Color(0xffe7e3cf),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('status: ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold)),
                      Text(dispStatus,
                          style: const TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Tick if completed',
                          style: TextStyle(fontSize: 12.0)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 40,
                      ),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                            checkColor: Colors.green,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white;
                              }
                              return Colors.white;
                            }),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: taskComplete == "true",
                            onChanged: (value) {
                              debugPrint('call on check box tick');
                              Map<String, String> toDoList = {
                                "id": list[idx].id.toString(),
                                "title": list[idx].title.toString(),
                                "start_date": list[idx].startdate.toString(),
                                "end_date": list[idx].endDate.toString(),
                                "status_complete": value.toString(),
                              };

                              debugPrint('to-do list: $toDoList');

                              Provider.of<ToDoListProvider>(context,
                                      listen: false)
                                  .updateToDoList(toDoList, context);
                            }),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
