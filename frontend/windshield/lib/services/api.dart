import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';
import 'package:windshield/models/balance_sheet/asset.dart';
import 'package:windshield/models/daily_flow/flow.dart';

import '../../models/user.dart';
import '../../models/provinces.dart';
import '../../models/statement/statement.dart';
import '../../models/statement/category.dart';
import '../../models/daily_flow/category.dart';
import '../../models/balance_sheet/balance_sheet.dart';

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
          options.path = 'http://192.168.1.36:8000' + options.path;
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
      return false;
    }
  }

  Future<User?> getUserInfo() async {
    try {
      final res = await dio.get('/user/${_user?.uuid}');
      print(res.toString());
      Map<String, dynamic> data = await jsonDecode(res.toString());
      _user = User.fromJson(data);
      return _user;
    } catch (e) {
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
      return null;
    }
  }

  //FINANCIAL STATEMENT PLAN
  Future<List<StmntStatement>> getAllNotEndYetStatements(DateTime date) async {
    try {
      final str = DateFormat('y-MM-dd').format(date);
      final res = await dio.get('/api/statement/?lower-date=$str',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (jsonDecode('${res.data}') as List)
          .map((i) => StmntStatement.fromJson(i))
          .toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<StmntCategory>> getAllCategories() async {
    try {
      final res = await dio.get('/api/categories/',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (json.decode(res.toString()) as List)
          .map((i) => StmntCategory.fromJson(i))
          .toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<String> createStatement(
    String name,
    String start,
    String end,
  ) async {
    try {
      final res = await dio.post(
        '/api/statement/',
        data: {
          "name": name,
          "start": start,
          "end": end,
          "month": 1,
        },
      );
      final data = StmntCategory.fromJson(jsonDecode(res.toString()));
      return data.id;
    } catch (e) {
      return '';
    }
  }

  Future<bool> updateStatementName(String id, String name) async {
    try {
      final res = await dio.patch(
        '/api/statement/$id/name/',
        data: {
          "name": name,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatementActive(String id) async {
    try {
      final res = await dio.patch('/api/statement/$id/');
      return true;
    } catch (e) {
      return false;
    }
  }

  //รายรับ-รายจ่าย
  Future<String> getTodayDFId() async {
    try {
      final res = await dio.get('/api/daily-flow-sheet/');
      final data = jsonDecode('$res');
      return data['id'];
    } catch (e) {
      return '';
    }
  }

  Future<List<DFlowCategory>> getAllCategoriesWithBudgetFlows(
      DateTime date) async {
    try {
      final str = DateFormat('y-MM-dd').format(date);
      final res = await dio.get('/api/categories-budgets-flows/?date=$str',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = (jsonDecode('$res') as List)
          .map((i) => DFlowCategory.fromJson(i))
          .toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<DFlowFlow> addFlow(
      String dfId, String catId, String name, double value, int method) async {
    try {
      final res = await dio.post(
        '/api/daily-flow/',
        data: {
          "id": "",
          "df_id": dfId,
          "category": catId,
          "name": name,
          "value": value,
          "method": method,
        },
      );
      final data = (jsonDecode('$res') as List)
          .map((i) => DFlowFlow.fromJson(i))
          .toList();
      return data[0];
    } catch (e) {
      return DFlowFlow(
        id: '',
        method: Method(id: 0, name: '', icon: ''),
        name: '',
        value: 0,
        detail: '',
        dfId: '',
        catId: '',
      );
    }
  }

  Future<DFlowFlow> editFlow(
      String id, String name, double value, int method) async {
    try {
      final res = await dio.patch(
        '/api/daily-flow/$id/',
        data: {
          "name": name,
          "value": value,
          "method": method,
        },
      );
      final data = DFlowFlow.fromJson(jsonDecode('$res'));
      return data;
    } catch (e) {
      return DFlowFlow(
        id: '',
        method: Method(id: 0, name: '', icon: ''),
        name: '',
        value: 0,
        detail: '',
        dfId: '',
        catId: '',
      );
    }
  }

  Future<String> deleteFlow(String id) async {
    try {
      final res = await dio.delete('/api/daily-flow/$id/');
      final data = DFlowFlow.fromJson(jsonDecode('$res'));
      return data.id;
    } catch (e) {
      return '';
    }
  }

  //งบดุลการเงิน
  Future<BSheetBalance?> getBalanceSheet() async {
    try {
      final res = await dio.get('/api/balance-sheet/',
          options: Options(
            responseType: ResponseType.plain,
          ));
      final data = BSheetBalance.fromJson(jsonDecode('$res'));
      return data;
    } catch (e) {
      return null;
    }
  }
}
