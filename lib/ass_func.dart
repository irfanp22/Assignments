import 'package:responsi1_b2/api.dart';
import 'dart:convert';
import 'package:responsi1_b2/assignment.dart';

class Bloc{

static Future<List<Assignment>> getAssignments() async {
    String apiUrl = Api.assignmentList;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> assignmentList = (jsonObj['result'] as List<dynamic>);
    List<Assignment> assignments = [];
    for (int i = 0; i < assignmentList.length; i++) {
      assignments.add(Assignment.fromJson(assignmentList[i]));
    }
    return assignments;
  }

  static Future addAssignment({Assignment? assignment}) async {
    String apiUrl = Api.createAssignment;

    var body = {
      "title": assignment!.title,
      "description": assignment.description,
      "deadline": assignment.deadline,
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateAssignment({required Assignment assignment}) async {
    String apiUrl = Api.updateAssignment(assignment.id!);
    print(apiUrl);

    var body = {
      "title": assignment.title,
      "description": assignment.description,
      "deadline": assignment.deadline,
    };
    print("Body : $body");
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteAssignment({int? id}) async {
    String apiUrl = Api.deleteAssignment(id!);
    var data = [];

    var response = await Api().post(apiUrl, data);
    var jsonObj = json.decode(response.body);
    return jsonObj['result'];
  }
}