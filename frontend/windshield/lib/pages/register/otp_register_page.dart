import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';

final apiOtp = FutureProvider.autoDispose<String>((ref) async {
  final data = await ref.read(apiProvider).requestOTP();
  return data;
});

class OTPRegisterPage extends ConsumerStatefulWidget {
  const OTPRegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OTPRegisterPageState();
}

class _OTPRegisterPageState extends ConsumerState<OTPRegisterPage> {
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiOtp);
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
          child: api.when(
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
                    onChanged: (value) => setState(() => {_otp = value}),
                    style: MyTheme.whiteTextTheme.headline4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'โปรดกรอก OTP',
                      labelStyle: MyTheme.whiteTextTheme.headline4,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.white),
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
                      final verify =
                          await ref.read(apiProvider).verifyOTP(_otp, refCode);
                      if (verify.isNotEmpty &&
                          await ref
                              .read(apiProvider)
                              .verifyUser(verify, refCode)) {
                        AutoRouter.of(context).pop();
                        AutoRouter.of(context).push(const PinRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('OTP หมดอายุหรือผิด กรุณาขอ OTP ใหม่'),
                          ),
                        );
                        AutoRouter.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ),
        ),
      ),
    );
  }
}
