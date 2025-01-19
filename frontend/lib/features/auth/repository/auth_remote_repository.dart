import 'dart:convert';
import 'package:frontend/core/%20error/server_exception.dart';
import 'package:frontend/core/constants/constant.dart';
import 'package:frontend/core/utils/shared_pref.dart';
import 'package:frontend/features/auth/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  final pref = SharedPref();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.baseUrl}/auth/signUp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            errorMessage: jsonDecode(response.body)['error'],
            statusCode: response.statusCode);
      }
      return UserModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.baseUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            errorMessage: jsonDecode(response.body)['error'],
            statusCode: response.statusCode);
      }
      return UserModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      String? token = await pref.getToken();
      if (token == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse("${Constants.baseUrl}/auth/tokenIsValid/"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode != 200 || jsonDecode(response.body) == false) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse("${Constants.baseUrl}/auth"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (userResponse.statusCode != 200) {
        throw ServerException(
            errorMessage: jsonDecode(response.body)['error'],
            statusCode: response.statusCode);
      }

      return UserModel.fromMap(jsonDecode(userResponse.body));
    } catch (e) {
      throw e.toString();
    }
  }
}
