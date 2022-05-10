import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/routes/app_router.dart';
import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _phone = '';
  bool _isLoading = false;

  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(15),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.shieldAlt,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            ' WINDSHIELD',
                            style: Theme.of(context).textTheme.headline2!.merge(
                                  const TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ],
                      ),
                      Text(
                        'สมัครสมาชิก',
                        style: Theme.of(context).textTheme.headline1!.merge(
                              const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
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
                          decoration: InputDecoration(
                            icon: const Icon(Icons.email),
                            labelText: 'อีเมล',
                            labelStyle: Theme.of(context).textTheme.headline4,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่อีเมล';
                            }
                            return null;
                          },
                          onSaved: (value) => setState(() => {_email = value!}),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            labelText: 'รหัสผ่าน',
                            labelStyle: Theme.of(context).textTheme.headline4,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่รหัสผ่าน';
                            }
                            return null;
                          },
                          controller: _password,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            labelText: 'ยืนยันรหัสผ่าน',
                            labelStyle: Theme.of(context).textTheme.headline4,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่รหัสผ่าน';
                            }
                            if (_password.text != _confirmPassword.text) {
                              return 'รหัสไม่ตรงกัน';
                            }
                            return null;
                          },
                          controller: _confirmPassword,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone),
                            labelText: 'เบอร์โทร',
                            labelStyle: Theme.of(context).textTheme.headline4,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่เบอร์โทร';
                            }
                            return null;
                          },
                          onSaved: (value) => setState(() => {_phone = value!}),
                        ),
                      ),
                      const SizedBox(height: 70),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _isLoading = true;
                              });
                              final res = await ref.read(apiProvider).register(
                                    _username,
                                    _password.text,
                                    _email,
                                    _phone,
                                  );
                              if (res) {
                                AutoRouter.of(context)
                                    .push(const OTPRegisterRoute());
                                // AutoRouter.of(context).push(const PinRoute());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('เกิดข้อผิดพลาด'),
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'สมัครสมาชิก',
                                    style: TextStyle(fontSize: 22),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
