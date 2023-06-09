import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/material.dart';
import 'package:windshield/models/article/article.dart';
import 'package:windshield/models/balance_sheet/flow_sheet.dart';
import 'package:windshield/pages/home/analysis/asset_debt/asset_debt_model.dart';
import 'package:windshield/pages/home/analysis/inc_exp/inc_exp_model.dart';
import 'package:windshield/pages/home/analysis/stat/stat_model.dart';

import '../../models/daily_flow/flow.dart';
import '../../models/statement/budget.dart';
import '../../models/user.dart';
import '../../models/provinces.dart';
import '../../models/statement/statement.dart';
import '../../models/statement/category.dart';
import '../../models/daily_flow/category.dart';
import '../../models/balance_sheet/balance_sheet.dart';
import '../../models/financial_goal/financial_goal.dart';
import '../../models/daily_flow/flow_speech.dart';
import '../models/balance_sheet/log.dart';
import '../pages/home/analysis/budget/budget_model.dart';

class Api extends ChangeNotifier {
  Dio dio = Dio();
  String? _accessToken;
  User? _user = User();
  bool _isLoggedIn = false;

  String? get accessToken => _accessToken;
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  final _storage = const FlutterSecureStorage();

  // final url = 'http://192.168.1.33:8000';
  final url = 'https://windshield-server.herokuapp.com';

  Api() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains('http')) {
          options.path = url + options.path;
        }
        options.headers['Authorization'] = 'JWT $_accessToken';
        if (options.path.contains('/user/register/') ||
            options.path.contains('/token/') ||
            options.path.contains('/token/refresh/') ||
            options.path.contains('/user/verify-code/?email=') ||
            options.path.contains('/user/reset-password/') ||
            (options.path.contains('/user/verify-code/') &&
                options.data.containsKey('email'))) {
          options.headers['Authorization'] = '';
        }
        // print(options.path + ' | ' + _accessToken.toString());
        print(options.path);
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        print(error.response);
        if (error.requestOptions.path.contains('token/refresh') ||
            (error.response?.data is! String &&
                error.response?.data.containsKey('detail') &&
                error.response?.data['detail'] == 'User not found')) {
          _accessToken = null;
          await _storage.delete(key: 'refreshToken');
          _isLoggedIn = false;
          notifyListeners();
          return handler.reject(error);
        }
        // if (error.requestOptions.path.contains('token/refresh') ||
        //     error.requestOptions.path.contains('user/')) {
        //   _accessToken = null;
        //   await _storage.delete(key: 'refreshToken');
        //   _isLoggedIn = false;
        //   notifyListeners();
        //   return handler.reject(error);
        // }

        if (error.response?.statusCode == 401 &&
            error.response?.statusMessage == 'Unauthorized') {
          final refresh = await _storage.read(key: 'refreshToken');
          if (refresh != null) {
            if (Jwt.isExpired(refresh)) {
              _accessToken = null;
              await _storage.delete(key: 'refreshToken');
              _isLoggedIn = false;
              notifyListeners();
              return handler.reject(error);
            } else {
              try {
                await refreshToken();
                return handler.resolve(await _retry(error.requestOptions));
              } catch (e) {
                print('FUCK MY LIFE');
              }
            }
          } else {
            _accessToken = null;
            await _storage.delete(key: 'refreshToken');
            _isLoggedIn = false;
            notifyListeners();
            return handler.reject(error);
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
    final data = dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
    return data;
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response = await dio.post(
      '/token/refresh/',
      data: {'refresh': refreshToken},
    );
    if (response.statusCode == 200) {
      _accessToken = response.data['access'];
      await _storage.write(
          key: 'refreshToken', value: response.data['refresh']);
      Map<String, dynamic> data = Jwt.parseJwt(response.data['access']);
      _user?.uuid = data['user_id'];
      // _isLoggedIn = true;
      // notifyListeners();
    }
  }

  Future<int> login(String username, String password) async {
    try {
      final res = await dio.post(
        '/token/',
        data: {
          'user_id': username,
          'password': password,
        },
      );
      _accessToken = res.data['access'];
      await _storage.write(key: 'refreshToken', value: res.data['refresh']);
      Map<String, dynamic> data = Jwt.parseJwt(res.data['access']);
      _user?.uuid = data['user_id'];
      await getUserInfo();
      if (_user?.isVerify == false) return 2;
      if (_user?.pin == null) return 3;
      if (_user?.family == null) return 4;
      // _isLoggedIn = true;
      // notifyListeners();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> loginByPin(String pin) async {
    try {
      final refresh = await _storage.read(key: 'refreshToken');
      final res = await dio.post('/token/refresh/', data: {'refresh': refresh});
      _accessToken = res.data['access'];
      await _storage.write(key: 'refreshToken', value: res.data['refresh']);
      Map<String, dynamic> data = Jwt.parseJwt(res.data['access']);
      _user?.uuid = data['user_id'];
      await getUserInfo();
      if (_user?.pin == pin) {
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'refreshToken');
    _user = User();
    _accessToken = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> register(
      String username, String password, String email, String phone) async {
    try {
      final user = await dio.post(
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
      final res = await dio.post(
        '/token/',
        data: {
          'user_id': username,
          'password': password,
        },
      );

      _accessToken = res.data['access'];
      await _storage.write(key: 'refreshToken', value: res.data['refresh']);
      Map<String, dynamic> data = Jwt.parseJwt(res.data['access']);
      _user?.uuid = data['user_id'];
      _user?.email = user.data['email'];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> requestOTP() async {
    try {
      // {
      //     "id": 19,
      //     "email": "phetdekde@hotmail.com",
      //     "send_at": "2022-05-10T01:23:14.638563+07:00",
      //     "ref_code": "um4pizha",
      //     "is_used": false,
      //     "count": 0
      // }
      final res = await dio.get(
        '/user/verify-code/?email=${_user?.email}',
        options: Options(
          headers: {'Authorization': ''},
        ),
      );
      return res.data['ref_code'];
    } catch (e) {
      return '';
    }
  }

  Future<String> verifyOTP(String otp, String ref) async {
    try {
      // {
      //     "massage": "verification success",
      //     "otp": "044503",
      //     "ref": "yt2n2kg6",
      //     "verify": "bzcdmb25qai5768j143by85jak46m4pi"
      // }
      final res = await dio.post('/user/verify-code/', data: {
        'otp': otp,
        'ref': ref,
      });
      return res.data['verify'];
    } catch (e) {
      return '';
    }
  }

  Future<String> requestAnonOTP(String email) async {
    try {
      final res = await dio.get(
        '/user/verify-code/?email=$email',
        options: Options(
          headers: {'Authorization': ''},
        ),
      );
      return res.data['ref_code'];
    } catch (e) {
      return '';
    }
  }

  Future<String> verifyAnonOTP(String email, String otp, String ref) async {
    try {
      final res = await dio.post(
        '/user/verify-code/',
        data: {
          'email': email,
          'otp': otp,
          'ref': ref,
        },
        options: Options(
          headers: {'Authorization': ''},
        ),
      );
      return res.data['verify'];
    } catch (e) {
      return '';
    }
  }

  Future<bool> verifyUser(String token, String ref) async {
    try {
      await dio.post(
        '/user/verify-user/',
        options: Options(
          headers: {
            'X-VERIFY-TOKEN': token,
            'X-REF-CODE': ref,
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String token, String ref, String password) async {
    try {
      await dio.post(
        '/user/reset-password/',
        data: {"new_password": password},
        options: Options(
          headers: {
            'Authorization': '',
            'X-VERIFY-TOKEN': token,
            'X-REF-CODE': ref,
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUserInfo() async {
    try {
      final res = await dio.get('/user/${_user?.uuid}');
      // Map<String, dynamic> data = await jsonDecode(res.toString());
      print(res.data);
      _user = User.fromJson(res.data);
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

  Future<bool> updateUser(String province, String status, String occuType,
      int family, int year) async {
    try {
      await dio.patch(
        '/user/${_user?.uuid}/',
        data: {
          "province": province,
          "status": status,
          "family": family,
          "occu_type": occuType,
          "born_year": year,
        },
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Province>?> getProvinces() async {
    try {
      final res = await dio.get('/api/provinces/');
      final data = (res.data as List).map((i) => Province.fromJson(i)).toList();
      return data;
    } catch (e) {
      return null;
    }
  }

  //แผนงบการเงิน
  Future<List<StmntStatement>> getAllNotEndYetStatements(DateTime date) async {
    try {
      final str = DateFormat('y-MM-dd').format(date);
      final res = await dio.get('/api/statement/?lower-date=$str');
      final data =
          (res.data as List).map((i) => StmntStatement.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<FlowSheet>> getRangeDailyFlowSheet(
      DateTime start, DateTime end) async {
    try {
      final strStart = DateFormat('y-MM-dd').format(start);
      final strEnd = DateFormat('y-MM-dd').format(end);
      final res = await dio
          .get('/api/daily-flow-sheet/list/?start=$strStart&end=$strEnd');
      final data =
          (res.data as List).map((i) => FlowSheet.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<StmntCategory>> getAllCategories(bool asUsed) async {
    try {
      final res = await dio
          .get('/api/categories/?as_used=${asUsed ? "True" : "False"}');
      final data =
          (res.data as List).map((i) => StmntCategory.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<String> createStatement(
    String name,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final res = await dio.post(
        '/api/statement/',
        data: {
          "name": name,
          "start": DateFormat('y-MM-dd').format(start),
          "end": DateFormat('y-MM-dd').format(end),
          "month": 1,
        },
      );
      return res.data['id'];
    } catch (e) {
      return '';
    }
  }

  Future<bool> deleteStatement(String id) async {
    try {
      await dio.delete('/api/statement/$id/');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatementName(String id, String name) async {
    try {
      await dio.patch('/api/statement/$id/name/', data: {"name": name});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatementActive(String id) async {
    try {
      await dio.patch('/api/statement/$id/');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createBudgets(List<StmntBudget> budgets, String id) async {
    try {
      final data = budgets.map((e) {
        e.fplan = id;
        return e.toJson();
      }).toList();
      await dio.post(
        '/api/budget/',
        data: data,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBudgets(List<StmntBudget> budgets, String id) async {
    try {
      final data = budgets.map((e) => e.toJsonUpdate()).toList();
      await dio.patch(
        '/api/budget/update/',
        data: data,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBudgets(List<String> budgets) async {
    try {
      await dio.delete('/api/budget/delete/', data: budgets);
      return true;
    } catch (e) {
      return false;
    }
  }

  //รายรับ-รายจ่าย
  Future<String> getTodayDFId(DateTime date) async {
    try {
      final str = DateFormat('y-MM-dd').format(date);
      final res = await dio.get('/api/daily-flow-sheet/?date=$str');
      return res.data['id'];
    } catch (e) {
      return '';
    }
  }

  Future<List<DFlowCategory>> getAllCategoriesWithBudgetFlows(
      DateTime date) async {
    try {
      final str = DateFormat('y-MM-dd').format(date);
      final res = await dio
          .get('/api/categories-budgets-flows/?as_used=True&date=$str');
      final data =
          (res.data as List).map((i) => DFlowCategory.fromJson(i)).toList();
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
          "df_id": dfId,
          "category": catId,
          "name": name,
          "value": value,
          "method": method,
        },
      );
      final data =
          (res.data as List).map((i) => DFlowFlow.fromJson(i)).toList();
      return data[0];
    } catch (e) {
      return DFlowFlow(
        id: '',
        method: Method(id: 0, name: '', icon: ''),
        name: '',
        value: 0,
        detail: '',
        dfId: '',
        cat: Cat(
          id: '',
          name: '',
          usedCount: 0,
          icon: '',
          ftype: '',
        ),
      );
    }
  }

  Future<bool> addFlowList(List<SpeechFlow> flowList) async {
    try {
      final data = flowList.map((e) => e.toJson()).toList();
      await dio.post(
        '/api/daily-flow/',
        data: data,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DFlowFlow> getOneFlow(String id) async {
    try {
      final res = await dio.get(
        '/api/daily-flow/$id/',
      );
      final data = DFlowFlow.fromJson(res.data);
      return data;
    } catch (e) {
      return DFlowFlow(
        id: '',
        method: Method(id: 0, name: '', icon: ''),
        name: '',
        value: 0,
        detail: '',
        dfId: '',
        cat: Cat(id: '', name: '', usedCount: 0, icon: '', ftype: ''),
      );
    }
  }

  Future<DFlowEdit> editFlow(
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
      final data = DFlowEdit.fromJson(res.data);
      return data;
    } catch (e) {
      return DFlowEdit(id: '');
    }
  }

  Future<String> deleteFlow(String id) async {
    try {
      final res = await dio.delete('/api/daily-flow/$id/');
      final data = DFlowFlow.fromJson(res.data);
      return data.id;
    } catch (e) {
      return '';
    }
  }

  //งบดุลการเงิน
  Future<BSheetBalance?> getBalanceSheet() async {
    try {
      final res = await dio.get('/api/balance-sheet/');
      final data = BSheetBalance.fromJson(res.data);
      return data;
    } catch (e) {
      return null;
    }
  }

  //Log
  Future<BSheetLog> getBalanceSheetLog() async {
    try {
      final res = await dio.get('/api/balance-sheet-log/');
      final data =
          (res.data as List).map((i) => BSheetLog.fromJson(i)).toList();
      return data.last;
    } catch (e) {
      return BSheetLog(
          id: 0,
          timestamp: DateTime.now(),
          assetValue: 0,
          debtValue: 0,
          bsheetId: '');
    }
  }

  Future<bool> addAsset(String source, double recentVal, String catId) async {
    try {
      await dio.post(
        '/api/asset/',
        data: {
          "source": source == '' ? null : source,
          "recent_value": recentVal,
          "cat_id": catId
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editAsset(String source, double recentVal, String id) async {
    try {
      await dio.patch(
        '/api/asset/$id/',
        data: {"source": source, "recent_value": recentVal},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //ลบ asset
  Future<bool> deleteAsset(String source, double recentVal, String id) async {
    try {
      await dio.delete(
        '/api/asset/$id/',
        data: {"source": source, "recent_value": recentVal},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addDebt(double bal, String cred, String catId, double interest,
      DateTime? date) async {
    try {
      await dio.post(
        '/api/debt/',
        data: {
          "balance": bal,
          "creditor": cred,
          "cat_id": catId,
          "interest": interest,
          "debt_term": date != null ? DateFormat('y-MM-dd').format(date) : null,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editDebt(double bal, String cred, String id, double interest,
      DateTime? date) async {
    try {
      await dio.patch(
        '/api/debt/$id/',
        data: {
          "balance": bal,
          "creditor": cred,
          "interest": interest,
          "debt_term": date != null ? DateFormat('y-MM-dd').format(date) : null,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //ลบ debt
  Future<bool> deleteDebt(double bal, String cred, String id, double interest,
      DateTime? date) async {
    try {
      await dio.delete(
        '/api/debt/$id/',
        data: {
          "balance": bal,
          "creditor": cred,
          "interest": interest,
          "debt_term": date != null ? DateFormat('y-MM-dd').format(date) : null,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //เพิ่ม category
  Future<bool> addCategory(String name, String icon, String ftype) async {
    try {
      await dio.post(
        '/api/categories/',
        data: {
          "name": name,
          "icon": icon == '' ? 'briefcase' : icon,
          "ftype": ftype,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //edit category
  Future<bool> editCategory(
    String id,
    String name,
    String icon,
  ) async {
    try {
      await dio.patch(
        '/api/category/$id/',
        data: {
          "name": name,
          "icon": icon == '' ? 'briefcase' : icon,
          //"ftype":ftype,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //ลบ category
  Future<bool> deleteCategory(
    String id,
  ) async {
    try {
      await dio.delete(
        '/api/category/$id/',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //เป้าหมายทางการเงิน
  Future<List<FGoal>> getAllGoals() async {
    try {
      final res = await dio.get('/api/financial-goal/');
      final data = (res.data as List).map((i) => FGoal.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<bool> addGoal(
    String name,
    String icon,
    double goal,
    DateTime start,
    DateTime? goalDate,
    String period,
    double progPerPeriod,
  ) async {
    try {
      await dio.post(
        '/api/financial-goal/',
        data: {
          "name": name,
          "icon": icon,
          "goal": goal,
          "start": DateFormat('y-MM-dd').format(start),
          "goal_date":
              goalDate != null ? DateFormat('y-MM-dd').format(goalDate) : null,
          "period_term": period,
          "progress_per_period": progPerPeriod
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editGoal(
    String id,
    String name,
    String icon,
    double goal,
    DateTime start,
    DateTime? goalDate,
    String period,
    double progPerPeriod,
  ) async {
    try {
      await dio.patch(
        '/api/financial-goal/$id/',
        data: {
          "name": name,
          "icon": icon,
          "goal": goal,
          "start": DateFormat('y-MM-dd').format(start),
          "goal_date":
              goalDate != null ? DateFormat('y-MM-dd').format(goalDate) : null,
          "period_term": period,
          "progress_per_period": progPerPeriod
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteGoal(String id) async {
    try {
      await dio.delete('/api/financial-goal/$id/');
      return true;
    } catch (e) {
      return false;
    }
  }

  // articles
  Future<Articles> getArticles(
    int page,
    String search,
    List<bool> ignore,
    String sort,
    bool isAsc,
    List<int> price,
  ) async {
    try {
      String ignoreStr = '';
      String searchStr = '';
      String sortStr = '';
      String priceStr = '';
      for (var i = 0; i < ignore.length; i++) {
        if (!ignore[i]) {
          if (i == 0) {
            ignoreStr = ignoreStr + '&ignore=พื้นฐาน';
          } else if (i == 1) {
            ignoreStr = ignoreStr + '&ignore=ข่าว/บทสัมภาษณ์';
          } else if (i == 2) {
            ignoreStr = ignoreStr + '&ignore=การลงทุน';
          } else {
            ignoreStr = ignoreStr + '&ignore=หนี้สิน';
          }
        }
      }
      if (search.isNotEmpty) searchStr = '&search=$search';
      if (sort.isNotEmpty) sortStr = '&sort_by=${isAsc ? sort : '-$sort'}';
      if (price.any((e) => e != 0)) {
        priceStr = '&lower_price=${price[0]}&upper_price=${price[1]}';
      }
      final res = await dio.get(
        '/api/articles/?page=$page$ignoreStr$searchStr$sortStr$priceStr',
      );
      final data = Articles.fromJson(res.data, url);
      return data;
    } catch (e) {
      return Articles(articles: [], pages: 0);
    }
  }

  Future<bool> unlockArticle(int id) async {
    try {
      await dio.get('/api/article/$id/unlock');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ArticleRead> readArticle(int id) async {
    try {
      final res = await dio.get('/api/article/$id/read');
      final data = ArticleRead.fromJson(res.data, url);
      return data;
    } catch (e) {
      return ArticleRead(
        id: 0,
        subject: [],
        like: false,
        body: '',
        topic: '',
        img: '',
        view: 0,
        price: 0,
        uploadDate: DateTime.now(),
        author: '',
      );
    }
  }

  Future<bool> likeArticle(int id) async {
    try {
      await dio.get('/api/article/$id/like');
      return true;
    } catch (e) {
      return false;
    }
  }

  // analysis
  Future<List<IncExpGraph>> analIncExpGraph(String type) async {
    try {
      final res = await dio.get('/api/daily-flow-sheet/graph/$type');
      final data =
          (res.data as List).map((i) => IncExpGraph.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<IncExp> analIncExp(int count) async {
    try {
      final res = await dio.get('/api/daily-flow-sheet/average/?days=$count');
      final data = IncExp.fromJson(res.data);
      return data;
    } catch (e) {
      return IncExp(
        avgInc: 0,
        avgIncWorking: 0,
        avgIncAsset: 0,
        avgIncOther: 0,
        avgExp: 0,
        avgExpInconsist: 0,
        avgExpConsist: 0,
        avgSavInv: 0,
      );
    }
  }

  Future<List<Budget>> analBudget() async {
    try {
      final res = await dio.get('/api/statement-summary/');
      final data = (res.data as List).map((i) => Budget.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<AssetDebtGraph>> analBsheetGraph() async {
    try {
      final res = await dio.get('/api/balance-sheet-log/');
      final data =
          (res.data as List).map((i) => AssetDebtGraph.fromJson(i)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<AssetDebt> analBsheet() async {
    try {
      final res = await dio.get('/api/balance-sheet/summary/');
      final data = AssetDebt.fromJson(res.data);
      return data;
    } catch (e) {
      return AssetDebt(
        maxAsset: 0,
        maxDebt: 0,
        maxBalance: 0,
        minAsset: 0,
        minDebt: 0,
        minBalance: 0,
        avgAsset: 0,
        avgDebt: 0,
        avgBalance: 0,
      );
    }
  }

  Future<Stat> analStat() async {
    try {
      final res = await dio.get('/api/financial-status/');
      final data = Stat.fromJson(res.data);
      return data;
    } catch (e) {
      return Stat(
        netWorth: 0,
        netCashFlow: 0,
        survivalRatio: 0,
        wealthRatio: 0,
        basicLiquidRatio: 0,
        debtServiceRatio: 0,
        savingRatio: 0,
        investRatio: 0,
        financialHealth: 0,
      );
    }
  }

  // setting
  Future<bool> changePassword(String oldPass, String newPass) async {
    try {
      await dio.post(
        '/user/change-password/',
        data: {"old_password": oldPass, "new_password": newPass},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePin(String pin, String ref, String verify) async {
    try {
      await dio.post(
        '/user/change-pin/',
        data: {"pin": pin},
        options: Options(
          headers: {
            'X-VERIFY-TOKEN': verify,
            'X-REF-CODE': ref,
          },
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
