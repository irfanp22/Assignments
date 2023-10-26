import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:responsi1_b2/app_exception.dart';

class Api {
  static const String baseUrl = 'https://responsi1b.dalhaqq.xyz/api';

 static const String assignmentList = baseUrl + '/assignments';
  static const String createAssignment = baseUrl + '/assignments';

  static String updateAssignment(int id) {
    return baseUrl + '/assignments/' + id.toString() + '/update';
  }

  static String showAssignment(int id) {
    return baseUrl + '/assignments/' + id.toString();
  }

  static String deleteAssignment(int id) {
    return baseUrl + '/assignments/' + id.toString() + '/delete';
  }
  Future<dynamic> post(dynamic url, dynamic data) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: data,
        );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url),
          );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
