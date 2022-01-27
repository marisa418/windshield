import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../models/provinces.dart';
import '../../models/statement.dart';
import '../../models/category.dart';

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
          options.path = 'http://192.168.1.34:8000' + options.path;
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
      await createCategory('00', 'เงินเดือน', 1);
      await createCategory('01', 'ค่าจ้าง', 1);
      await createCategory('02', 'ค่าล่วงเวลา', 1);
      await createCategory('03', 'โบนัส', 1);
      await createCategory('04', 'ค่าคอมมิชชั่น', 1);
      await createCategory('05', 'กำไรจากธุรกิจ', 1);
      await createCategory('06', 'ดอกเบี้ย', 2);
      await createCategory('07', 'เงินปันผล', 2);
      await createCategory('08', 'ค่าเช่า', 2);
      await createCategory('09', 'ขายสินทรัพย์', 2);
      await createCategory('10', 'เงินรางวัล', 3);
      await createCategory('11', 'ค่าเลี้ยงดู', 3);

      await createCategory('12', 'อาหาร/เครื่่องดื่ม', 4);
      await createCategory('13', 'ภายในครัวเรือน', 4);
      await createCategory('14', 'ความบันเทิง/ความสุขส่วนบุคคล', 4);
      await createCategory('15', 'สาธารณูปโภค', 4);
      await createCategory('16', 'ดูแลตัวเอง', 4);
      await createCategory('17', 'ค่าเดินทาง', 4);
      await createCategory('18', 'รักษาพยาบาล', 4);
      await createCategory('19', 'ดูแลบุพการี', 4);
      await createCategory('20', 'ดูแลบุตร', 4);
      await createCategory('21', 'ภาษี', 4);
      await createCategory('22', 'ชำระหนี้', 4);
      await createCategory('23', 'เสี่ยงดวง', 4);
      await createCategory('24', 'กิจกรรมทางศาสนา ', 4);

      await createCategory('25', 'เช่าบ้าน', 5);
      await createCategory('26', 'หนี้ กยศ. กองทุน กยศ.', 5);
      await createCategory('27', 'ผ่อนรถ', 5);
      await createCategory('28', 'ผ่อนสินค้า', 5);
      await createCategory('29', 'ผ่อนหนี้นอกระบบ', 5);
      await createCategory('30', 'ผ่อนสินเชื่อส่วนบุคคล', 5);

      await createCategory('31', 'ประกันสังคม', 6);
      await createCategory('32', 'กองทุนสำรองเลี้ยงชีพ', 6);
      await createCategory('33', 'กอนทุน กบข.', 6);
      await createCategory('34', 'สหกรณ์ออมทรัพย์', 6);
      await createCategory('35', 'เงินออม', 6);
      await createCategory('36', 'เงินลงทุน', 6);

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
      final res =
          await dio.get('/api/statement?uuid=${_user?.uuid}&ordering=month,id',
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
      final res = await dio.get('/api/category/',
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

  Future<bool> createStatement(String start, String end) async {
    try {
      final monthString = start[5] + start[6];
      _placeholderId++;
      final res = await dio.post(
        '/api/statement/',
        data: {
          "id": _placeholderId.toString(),
          "name": "แผน$_placeholderId | เดือน $monthString",
          "chosen": true,
          "start": start,
          "end": end,
          "owner_id": _user?.uuid,
          "month": int.parse(monthString)
        },
      );
      print(res);

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
}
