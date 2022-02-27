import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../models/provinces.dart';
import '../../models/statement.dart';
import '../../models/category.dart';
import '../../models/budget.dart';

class Api extends ChangeNotifier {
  Dio dio = Dio();
  String? _accessToken;
  User? _user = User();

  int _placeholderId = 0;

  String? get accessToken => _accessToken;
  User? get user => _user;

  final _storage = const FlutterSecureStorage();

  Api() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains('http')) {
          options.path = 'http://192.168.106.1:8000' + options.path;
        }
        options.headers['Authorization'] = 'JWT $_accessToken';
        if (options.path.contains('/user/register/')) {
          options.headers['Authorization'] = '';
        }
        print(options.path + ' | ' + _accessToken.toString());
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401 &&
            error.response?.statusMessage == 'Unauthorized') {
          if (await _storage.containsKey(key: 'refreshToken')) {
            await refreshToken();
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response =
        await dio.post('/token/refresh', data: {'refreshToken': refreshToken});
    if (response.statusCode == 201) {
      _accessToken = response.data;
    } else {
      //refresh is wrong
      _accessToken = null;
      _storage.deleteAll();
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/token/',
        data: {
          'user_id': username,
          'password': password,
        },
      );
      Map<String, dynamic> token = jsonDecode(response.toString());
      _accessToken = token['access'];
      Map<String, dynamic> data = Jwt.parseJwt(token['access']);
      _user?.uuid = data['user_id'];
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(
      String username, String password, String email, String phone) async {
    try {
      await dio.post(
        '/user/register/',
        options: Options(
          headers: {'Authorization': ''},
        ),
        data: {
          'user_id': username,
          'password': password,
          'email': email,
          'tel': phone,
        },
      );
      final res = await login(username, password);
      if (!res) return false;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User?> getUserInfo() async {
    try {
      final res = await dio.get('/user/${_user?.uuid}');
      print(res.toString());
      Map<String, dynamic> data = await jsonDecode(res.toString());
      _user = User.fromJson(data);
      print(_user?.props);
      return _user;
    } catch (e) {
      print(e);
      return _user;
    }
  }

  Future<bool> updatePin(String pin) async {
    try {
      await dio.patch(
        '/user/${_user?.uuid}/',
        data: {
          'pin': pin,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUser(
      String province, String status, String occuType, int family) async {
    try {
      await dio.patch(
        '/user/${_user?.uuid}/',
        data: {
          "province": province,
          "status": status,
          "family": family.toString(),
          "occu_type": occuType,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Province>?> getProvinces() async {
    try {
      final res = await dio.get('/api/provinces/',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (json.decode(res.toString()) as List)
          .map((i) => Province.fromJson(i))
          .toList();
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Statement>> getAllStatements() async {
    try {
      final res = await dio.get('/api/statement?ordering=month,id',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (json.decode(res.toString()) as List)
          .map((i) => Statement.fromJson(i))
          .toList();
      // notifyListeners();
      return data;
    } catch (e) {
      print(e);
      // notifyListeners();
      return [];
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final res = await dio.get('/api/categories/',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (json.decode(res.toString()) as List)
          .map((i) => Category.fromJson(i))
          .toList();
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> createStatement(
      String start, String end, List<Budget> budgetList) async {
    try {
      DateTime startTemp = DateFormat('y-MM-dd').parse(start);
      DateTime endTemp = DateFormat('y-MM-dd').parse(start);
      DateTime lastDayOfEndTemp = DateTime(endTemp.year, endTemp.month + 1, 0);
      int month = startTemp.month;
      if (lastDayOfEndTemp.difference(startTemp).inDays + 1 <= 7) {
        month++;
      }

      final res = await dio.post(
        '/api/statement/',
        data: {
          "name": "แผนที่ 1",
          "chosen": true,
          "start": start,
          "end": end,
          "month": month
        },
      );
      print(res);
      final jsonList = budgetList.map((e) {
        e.fplan = res.data['id'];
        return e.toJson();
      }).toList();
      final res2 = await dio.post(
        '/api/budget/',
        data: jsonList,
      );
      print(res2);
      // notifyListeners();
      return true;
    } catch (e) {
      print(e);
      // notifyListeners();
      return false;
    }
  }

  Future<bool> createCategory(String id, String name, int ftype) async {
    try {
      final res = await dio.post(
        '/api/category/',
        data: {
          "id": id,
          "name": name,
          "usedCount": 0,
          "ftype": ftype.toString(),
          "user_id": _user?.uuid,
        },
      );
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getBalanceSheet() async {
    try {
      final res = await dio.get('/api/balance-sheet');
      print(res);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
