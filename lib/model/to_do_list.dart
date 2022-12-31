class ToDoList {
  //Awann = 27 Dec 2022
  //create to do list model
  final int? id;
  final String? title;
  final String? status;
  final String? startdate;
  final String? endDate;

  ToDoList({this.id, this.title, this.status, this.startdate, this.endDate});

  //use mapping so that we can use it  in JSON or Databse later
  ToDoList.fromMap(Map<String, dynamic> response)
      : id = response['id'],
        title = response['title'],
        status = response['status'],
        startdate = response['startDate'],
        endDate = response['endDate'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'startDate': startdate,
      'endDate': endDate,
    };
  }
}
