import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  static const initialTimerTime = 10;
  int secondsRemaining = initialTimerTime;
  bool isTimerRunning = false;
  late Timer timer;
  String? phoneNumber;
  String? verificationCode;
  bool isPhoneNumberValid = false;
  bool isVerificationCodeValid = false;
  final verificationCodeTextFieldController = TextEditingController();

  void onTick(Timer timer) {
    if (secondsRemaining == 0) {
      setState(() {
        isTimerRunning = false;
        secondsRemaining = initialTimerTime;
        timer.cancel();
      });
    } else {
      setState(() {
        secondsRemaining -= 1;
      });
    }
  }

  String secondsToString(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().substring(2, 7);
  }

  void onSendCodeButtonPressed() {
    FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
    verificationCodeTextFieldController.clear();
    isVerificationCodeValid = false;

    if (isTimerRunning) {
      timer.cancel();
      secondsRemaining = initialTimerTime;
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isTimerRunning = true;
    });
  }

  String? phoneNumberValidationString(value) {
    if (value?.isEmpty ?? true) {
      return '전화번호를 입력해주세요.';
    } else if (!RegExp(r'^01([0|1|6|7|8|9])([0-9]{7,8})$').hasMatch(value!)) {
      return '전화번호를 입력해주세요!';
    }
    return null;
  }

  String? verificationCodeValidationString(value) {
    if (value.isEmpty ?? true) {
      return '인증번호를 입력해주세요.';
    } else if (!RegExp(r'^([0-9]{6})$').hasMatch(value!)) {
      return '인증번호를 입력해주세요!';
    }
    return null;
  }

  bool checkPhoneNumberValid(value) {
    if (value?.isEmpty ?? true) {
      return false;
    } else if (!RegExp(r'^01([0|1|6|7|8|9])([0-9]{7,8})$').hasMatch(value!)) {
      return false;
    }
    return true;
  }

  bool checkVerificationCodeValid(value) {
    if (value.isEmpty ?? true) {
      return false;
    } else if (!RegExp(r'^([0-9]{6})$').hasMatch(value!)) {
      return false;
    }
    return true;
  }

  bool isCodeValid({
    required String phoneNumber,
    required String verificationCode,
  }) {
    return verificationCode == '000000';
  }

  void onVerifyCodeButtonPressed({
    required String phoneNumber,
    required String verificationCode,
  }) {
    if (isCodeValid(
        phoneNumber: phoneNumber, verificationCode: verificationCode)) {
      print('Code valid');
      Navigator.pop(context);
    } else {
      print('Code not valid');
      FocusScope.of(context).requestFocus(_verificationCodeFocusNode);
      verificationCodeTextFieldController.clear();
      isVerificationCodeValid = false;
    }
  }

  @override
  void dispose() {
    _verificationCodeFocusNode.dispose();
    if (isTimerRunning) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴대폰 본인인증'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, // 뒤로가기
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        decoration: const InputDecoration(labelText: '전화번호'),
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        initialValue: '010',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: phoneNumberValidationString,
                        onChanged: (value) {
                          setState(() {
                            isPhoneNumberValid = checkPhoneNumberValid(value);
                          });
                        },
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed:
                          isPhoneNumberValid ? onSendCodeButtonPressed : null,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        backgroundColor: const Color(0xff81ccd1),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('인증번호 전송'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(labelText: '인증번호'),
                  keyboardType: TextInputType.number,
                  focusNode: _verificationCodeFocusNode,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: verificationCodeValidationString,
                  onChanged: (value) {
                    setState(() {
                      isVerificationCodeValid =
                          checkVerificationCodeValid(value);
                    });
                  },
                  controller: verificationCodeTextFieldController,
                  onSaved: (value) {
                    verificationCode = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: isTimerRunning & isVerificationCodeValid
                        ? () {
                            _formKey.currentState?.save();
                            onVerifyCodeButtonPressed(
                              phoneNumber: phoneNumber!,
                              verificationCode: verificationCode!,
                            );
                            timer.cancel();
                            isTimerRunning = false;
                            secondsRemaining = initialTimerTime;
                            setState(() {});
                          }
                        : null, //본인인증 바로가기
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      backgroundColor: const Color(0xff81ccd1),
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                        '확인 ${isTimerRunning ? secondsToString(secondsRemaining) : ''}'),
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
