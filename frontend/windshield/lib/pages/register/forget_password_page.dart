import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';

class ForgetPasswordPage extends ConsumerStatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  String _email = '';
  bool _showOTP = false;
  bool _showNewEmail = false;
  String _refCode = '';
  String _otp = '';
  String _verify = '';
  String _newPass = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: MyTheme.majorBackground,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!_showOTP && !_showNewEmail) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextFormField(
                    style: MyTheme.whiteTextTheme.headline4,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    onChanged: (e) => setState(() {
                      _email = e;
                    }),
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      labelText: 'โปรดกรอกอีเมลที่ท่านใช้สมัคร',
                      labelStyle: MyTheme.whiteTextTheme.headline4,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showLoading(context);
                      final refCode =
                          await ref.read(apiProvider).requestAnonOTP(_email);
                      if (refCode.isNotEmpty) {
                        setState(() {
                          _showOTP = true;
                          _refCode = refCode;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ไม่สามารถส่ง OTP'),
                          ),
                        );
                      }
                      FocusManager.instance.primaryFocus!.unfocus();
                      AutoRouter.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(
                      'ส่ง OTP ไปที่อีเมล',
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(color: MyTheme.primaryMajor),
                      ),
                    ),
                  ),
                ),
              ] else if (_showOTP && !_showNewEmail) ...[
                Text(
                  'REF: $_refCode',
                  style: MyTheme.whiteTextTheme.headline3,
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        onChanged: (e) => setState(() => {_otp = e}),
                        style: MyTheme.whiteTextTheme.headline4,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'โปรดกรอก OTP',
                          labelStyle: MyTheme.whiteTextTheme.headline4,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showLoading(context);
                        final refCode =
                            await ref.read(apiProvider).requestAnonOTP(_email);
                        if (refCode.isNotEmpty) {
                          setState(() {
                            _showOTP = true;
                            _refCode = refCode;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ไม่สามารถส่ง OTP'),
                            ),
                          );
                        }
                        FocusManager.instance.primaryFocus!.unfocus();
                        AutoRouter.of(context).pop();
                      },
                      child: Text(
                        'ขอ OTP ใหม่',
                        style: MyTheme.whiteTextTheme.headline3,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          showLoading(context);
                          final verify = await ref
                              .read(apiProvider)
                              .verifyAnonOTP(_email, _otp, _refCode);
                          if (verify.isNotEmpty) {
                            setState(() {
                              _showNewEmail = true;
                              _verify = verify;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('OTP หมดอายุหรือผิด กรุณาขอ OTP ใหม่'),
                              ),
                            );
                          }
                          FocusManager.instance.primaryFocus!.unfocus();
                          AutoRouter.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          'ยืนยัน OTP',
                          style: MyTheme.textTheme.headline4!.merge(
                            TextStyle(color: MyTheme.primaryMajor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextFormField(
                    style: MyTheme.whiteTextTheme.headline4,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    onChanged: (e) => setState(() {
                      _newPass = e;
                    }),
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      labelText: 'โปรดกรอกรหัสผ่านใหม่',
                      labelStyle: MyTheme.whiteTextTheme.headline4,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showLoading(context);
                      final complete = await ref
                          .read(apiProvider)
                          .resetPassword(_verify, _refCode, _newPass);
                      if (complete) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
                          ),
                        );
                        AutoRouter.of(context)
                            .popUntilRouteWithName('LoginRoute');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ไม่สามารถส่ง OTP'),
                          ),
                        );
                        FocusManager.instance.primaryFocus!.unfocus();
                        AutoRouter.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(
                      'ยืนยันรหัสผ่านใหม่',
                      style: MyTheme.textTheme.headline4!.merge(
                        TextStyle(color: MyTheme.primaryMajor),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
