import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../main.dart';
import '../models/user.dart';

class PinPage extends ConsumerStatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder<User?>(
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
                  child: PinField(),
                );
              } else {
                return Container();
              }
            }
          }
        },
      ),
    );
  }
}

class PinField extends ConsumerStatefulWidget {
  PinField({Key? key}) : super(key: key);

  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends ConsumerState {
  final TextEditingController PinFieldController = TextEditingController();
  final FocusNode PinFieldFocusNode = FocusNode();

  ElevatedButton _keyPad(String num) {
    return ElevatedButton(
      onPressed: () {
        if (num == '-1') {
          if (PinFieldController.text.isNotEmpty) {
            PinFieldController.text = PinFieldController.text.substring(
              0,
              PinFieldController.text.length - 1,
            );
          }
        } else {
          if (PinFieldController.text.length <= 6) {
            PinFieldController.text += num;
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

  BoxDecoration get PinFieldDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiProvider);
    return Builder(
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  child: PinPut(
                    useNativeKeyboard: false,
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    fieldsCount: 6,
                    // onSubmit: (String pin) => _showSnackBar(pin, context),
                    focusNode: PinFieldFocusNode,
                    controller: PinFieldController,
                    submittedFieldDecoration: PinFieldDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedFieldDecoration: PinFieldDecoration,
                    followingFieldDecoration: PinFieldDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // const Divider(),
                Column(
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
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (await _updatePin(PinFieldController.text)) {
                          AutoRouter.of(context)
                              .push(const RegisterInfoRoute());
                        } else {
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _updatePin(String inputPin) async {
    return await ref.read(apiProvider).updatePin(inputPin);
  }
}
