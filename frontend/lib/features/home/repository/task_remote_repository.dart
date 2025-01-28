import 'dart:convert';
import 'package:frontend/core/%20error/server_exception.dart';
import 'package:frontend/core/constants/constant.dart';
import 'package:frontend/core/utils/shared_pref.dart';
import 'package:frontend/features/home/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  SharedPref pref = SharedPref();
  Future<TaskModel> addTask(TaskModel taskModel) async {
    try {
      String? token = await pref.getToken();
      // 🚨 Handle missing token case
      if (token == null) {
        throw Exception("Token is missing. Please log in again.");
      }
      final response = await http.post(
          Uri.parse("${Constants.baseUrl}/tasks/addTask"),
          headers: {'Content-Type': 'application/json', 'x-auth-token': token},
          body: jsonEncode(taskModel.toMap()));
      if (response.statusCode != 200) {
        throw ServerException(errorMessage: jsonDecode(response.body)['error']);
      }

      return TaskModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }
}
