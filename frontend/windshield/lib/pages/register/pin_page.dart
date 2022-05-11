import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:windshield/components/loading.dart';
import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:pinput/pinput.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/models/user.dart';

class PinPage extends ConsumerStatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // color: Colors.transparent,
        body: FutureBuilder<User?>(
          future: ref.read(apiProvider).getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                if (snapshot.data?.pin == null) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(255, 82, 84, 255),
                          Color.fromARGB(255, 117, 161, 227),
                        ],
                      ),
                    ),
                    child: const PinField(),
                  );
                } else {
                  return Container();
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class PinField extends ConsumerStatefulWidget {
  const PinField({Key? key}) : super(key: key);

  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends ConsumerState {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'กำหนด Pin',
              style: MyTheme.whiteTextTheme.headline3,
            ),
          ),
        ),
        Flexible(
          flex: 25,
          fit: FlexFit.tight,
          child: Container(
            height: 100,
            // margin: const EdgeInsets.all(20.0),
            // padding: const EdgeInsets.all(20.0),
            child: Pinput(
              useNativeKeyboard: false,
              obscureText: true,
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
        ),
        Flexible(
          flex: 55,
          fit: FlexFit.tight,
          child: Column(
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
              const SizedBox(height: 20),
            ],
          ),
        ),
        Flexible(
          flex: 15,
          child: ElevatedButton(
            onPressed: () async {
              showLoading(context);
              final _updatePin = ref.read(apiProvider);
              final pin = pinController.text;
              if (pin.length > 4 && await _updatePin.updatePin(pin)) {
                AutoRouter.of(context).pop();
                AutoRouter.of(context).push(const RegisterInfoRoute());
              } else {
                AutoRouter.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: Colors.white,
              elevation: 0,
            ),
            child: Container(
              height: 60,
              width: 300,
              alignment: Alignment.center,
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
      ],
    );
  }
}
