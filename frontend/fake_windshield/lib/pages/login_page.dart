import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

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
    // final api = ref.watch(apiProvider);
    return Material(
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
                      Palette.kToDark.shade300
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
                        labelStyle: GoogleFonts.kanit(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่ชื่อผู้ใช้งาน';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => {_username = value!}),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: 'รหัสผ่าน',
                        labelStyle: GoogleFonts.kanit(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่รหัสผ่าน';
                        }
                        return null;
                      },
                      onSaved: (value) => setState(() => {_password = value!}),
                    ),
                  ),
                  const SizedBox(height: 200),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final res = await ref
                            .read(apiProvider)
                            .login(_username, _password);
                        if (res) {
                          AutoRouter.of(context).replace(const MyHomeRoute());
                        } else {
                          print('SOMETHING WENT WRONG');
                        }
                      }
                    },
                    child: Text('เข้าสู่ระบบ', style: GoogleFonts.kanit()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AutoRouter.of(context).push(const RegisterRoute());
                    },
                    child: Text('สมัครสมาชิก', style: GoogleFonts.kanit()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
