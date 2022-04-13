import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pinput/pinput.dart';

import 'package:windshield/routes/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/main.dart';

final refreshAlive = FutureProvider.autoDispose<bool>((ref) async {
  const _storage = FlutterSecureStorage();
  final refresh = await _storage.read(key: 'refreshToken');
  if (refresh == null || Jwt.isExpired(refresh)) {
    return false;
  } else {
    return true;
  }
});

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(refreshAlive).when(
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (refreshAlive) {
            return SafeArea(
              child: Scaffold(
                body: refreshAlive ? const Pin() : const Credential(),
              ),
            );
          },
        );
  }
}

class Pin extends ConsumerStatefulWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinState();
}

class _PinState extends ConsumerState<Pin> {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: MyTheme.majorBackground,
        ),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0),
            child: Pinput(
              useNativeKeyboard: false,
              length: 6,
              followingPinTheme: PinTheme(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(.5),
                  ),
                  color: Colors.white.withOpacity(.5),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 40,
                height: 40,
                textStyle: MyTheme.whiteTextTheme.headline4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ),
              focusNode: focusNode,
              controller: pinController,
              onCompleted: (text) async {
                final api = ref.read(apiProvider);
                if (text.length > 4 && await api.loginByPin(text)) {
                  // AutoRouter.of(context).push(const RegisterInfoRoute());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                  );
                }
              },
            ),
          ),
          Expanded(
            // flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _keyPad('7'),
                    _keyPad('8'),
                    _keyPad('9'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _keyPad('4'),
                    _keyPad('5'),
                    _keyPad('6'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _keyPad('1'),
                    _keyPad('2'),
                    _keyPad('3'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(width: 92, height: 60),
                    _keyPad('0'),
                    _keyPad('-1'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  ref.read(apiProvider).logout();
                  ref.refresh(refreshAlive);
                },
                child: Text(
                  'ออกจากระบบ   ',
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _keyPad(String num) {
    return ElevatedButton(
      onPressed: () {
        if (num == '-1') {
          if (pinController.text.isNotEmpty) {
            pinController.text = pinController.text.substring(
              0,
              pinController.text.length - 1,
            );
          }
        } else {
          if (pinController.length <= 5) {
            pinController.text += num;
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: Colors.transparent,
        elevation: 0,
      ),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: const Color.fromARGB(255, 82, 84, 255),
          border: Border.all(color: Colors.white),
        ),
        child: num == '-1'
            ? const Icon(Icons.backspace)
            : Text(
                num,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class Credential extends ConsumerStatefulWidget {
  const Credential({Key? key}) : super(key: key);

  @override
  _CredentialState createState() => _CredentialState();
}

class _CredentialState extends ConsumerState<Credential> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: MyTheme.majorBackground,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.shieldAlt,
                      size: 70,
                      color: Colors.white,
                    ),
                    Text(
                      'WINDSHIELD',
                      style: MyTheme.whiteTextTheme.headline1,
                    ),
                    Text(
                      'ตัวช่วยสำหรับการวางแผนจัดการเงินของคุณ',
                      style: MyTheme.whiteTextTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 7,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: 'ชื่อผู้ใช้งาน',
                          labelStyle: Theme.of(context).textTheme.headline4,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'โปรดใส่ชื่อผู้ใช้งาน';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            setState(() => {_username = value!}),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          labelText: 'รหัสผ่าน',
                          labelStyle: Theme.of(context).textTheme.headline4,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'โปรดใส่รหัสผ่าน';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            setState(() => {_password = value!}),
                      ),
                    ),
                    const SizedBox(height: 80),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final res = await ref
                              .read(apiProvider)
                              .login(_username, _password);

                          if (!res) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
                              ),
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Ink(
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'เข้าสู่ระบบ',
                              style:
                                  Theme.of(context).textTheme.headline3!.merge(
                                        const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () =>
                          AutoRouter.of(context).push(const RegisterRoute()),
                      child: Ink(
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 3,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'สมัครสมาชิก',
                              style:
                                  Theme.of(context).textTheme.headline3!.merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
