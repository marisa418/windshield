import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/routes/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
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
                        colors: [
                          Theme.of(context).primaryColor,
                          MyTheme.kToDark.shade300
                        ]),
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
                        style: Theme.of(context).textTheme.headline1!.merge(
                              const TextStyle(
                                color: Colors.white,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                      Text(
                        'ตัวช่วยสำหรับการวางแผนจัดการเงินของคุณ',
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                // letterSpacing: 5,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            if (res) {
                              AutoRouter.of(context).replace(const HomeRoute());
                            } else {
                              print('SOMETHING WENT WRONG');
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .merge(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .merge(
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
      ),
    );
  }
}
