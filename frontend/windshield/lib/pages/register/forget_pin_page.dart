import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';

final apiOtp = FutureProvider.autoDispose<String>((ref) async {
  final data = await ref.read(apiProvider).requestOTP();
  return data;
});

class ForgetPinPage extends ConsumerStatefulWidget {
  const ForgetPinPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgetPinPageState();
}

class _ForgetPinPageState extends ConsumerState<ForgetPinPage> {
  String _otp = '';
  String _old = '';
  String _new = '';
  String _ref = '';
  String _verify = '';
  bool _nextPage = false;
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

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
            child: () {
              if (_nextPage) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 10,
                      fit: FlexFit.tight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'ตั้งค่า Pin ใหม่',
                          style: MyTheme.whiteTextTheme.headline3,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 15,
                      fit: FlexFit.tight,
                      child: Pinput(
                        obscureText: true,
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
                      ),
                    ),
                    Flexible(
                      flex: 55,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width - 50,
                        child: GridView.builder(
                          itemCount: 12,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 50,
                            crossAxisSpacing: 5,
                            mainAxisExtent: 60,
                          ),
                          itemBuilder: (_, i) {
                            final List<int> list = [
                              1,
                              2,
                              3,
                              4,
                              5,
                              6,
                              7,
                              8,
                              9,
                              -1,
                              0,
                              -1
                            ];
                            if (i == 9) return Container();
                            return ElevatedButton(
                              onPressed: () {
                                if (i == 11) {
                                  if (pinController.text.isNotEmpty) {
                                    pinController.text =
                                        pinController.text.substring(
                                      0,
                                      pinController.text.length - 1,
                                    );
                                  }
                                } else {
                                  if (pinController.length <= 5) {
                                    pinController.text += list[i].toString();
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
                                  border: Border.all(color: Colors.white),
                                ),
                                child: i == 11
                                    ? const Icon(Icons.backspace)
                                    : Text(
                                        '${list[i]}',
                                        style: MyTheme.whiteTextTheme.headline4,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 20,
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              final pin = pinController.text;
                              if (pin.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('โปรดกรอกให้ครบ'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              showLoading(context);
                              final complete =
                                  await ref.read(apiProvider).changePin(
                                        pin,
                                        _ref,
                                        _verify,
                                      );
                              if (complete) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'เปลี่ยน Pin สมบูรณ์',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                AutoRouter.of(context)
                                    .popUntilRouteWithName('LoginRoute');
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('เกิดข้อผิดพลาด'),
                                ),
                              );
                              AutoRouter.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              primary: Colors.white,
                              elevation: 0,
                              // fixedSize: const Size(100, 10),
                            ),
                            child: const Text(
                              'บันทึก',
                              style: TextStyle(
                                color: Color.fromARGB(255, 82, 84, 255),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return ref.watch(apiOtp).when(
                      error: (err, _) => Text(err.toString()),
                      loading: () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'กำลังดำเนินการ...',
                            style: MyTheme.whiteTextTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                          const CircularProgressIndicator(),
                        ],
                      ),
                      data: (refCode) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'เราได้ทำการส่งรหัส OTP\nไปที่อีเมลของคุณเรียบร้อยแล้ว',
                            style: MyTheme.whiteTextTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                          Text(
                            'REF: $refCode',
                            style: MyTheme.whiteTextTheme.headline3,
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: TextFormField(
                              onChanged: (value) =>
                                  setState(() => {_otp = value}),
                              style: MyTheme.whiteTextTheme.headline4,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                labelText: 'โปรดกรอก OTP',
                                labelStyle: MyTheme.whiteTextTheme.headline4,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: () => ref.refresh(apiOtp),
                            child: Text(
                              'ขอ OTP ใหม่',
                              style: MyTheme.whiteTextTheme.headline3,
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () async {
                                showLoading(context);
                                final verify = await ref
                                    .read(apiProvider)
                                    .verifyOTP(_otp, refCode);
                                if (verify.isNotEmpty) {
                                  setState(() {
                                    _nextPage = true;
                                    _verify = verify;
                                    _ref = refCode;
                                  });
                                  AutoRouter.of(context).pop();
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'OTP หมดอายุหรือผิด กรุณาขอ OTP ใหม่',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'ต่อไป',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: MyTheme.primaryMajor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
              }
            }()),
      ),
    );
  }
}
