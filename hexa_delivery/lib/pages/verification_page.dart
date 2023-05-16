import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_delivery/widgets/buttons.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final verificationCodeFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  static const initialTimerSeconds = 10;
  int secondsRemaining = initialTimerSeconds;
  bool isTimerRunning = false;
  late Timer timer;
  String? phoneNumber;
  String? verificationCode;
  bool isPhoneNumberValid = false;
  bool isVerificationCodeValid = false;
  final verificationCodeTextFieldController = TextEditingController();
  bool showCodeNotValidErrorMessage = false;

  void resetTimer() {
    isTimerRunning = false;
    secondsRemaining = initialTimerSeconds;
    timer.cancel();
  }

  void onTick(Timer timer) {
    if (secondsRemaining == 0) {
      resetTimer();
      setState(() {});
    } else {
      secondsRemaining -= 1;
      setState(() {});
    }
  }

  String secondsToString(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().substring(2, 7);
  }

  void onSendCodeButtonPressed() {
    FocusScope.of(context).requestFocus(verificationCodeFocusNode);
    verificationCodeTextFieldController.clear();
    isVerificationCodeValid = false;

    if (isTimerRunning) {
      resetTimer();
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    isTimerRunning = true;
    setState(() {});
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
    if (showCodeNotValidErrorMessage) {
      showCodeNotValidErrorMessage = false;
      return '인증번호가 틀립니다!';
    }
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
      Navigator.pop(context);
    } else {
      FocusScope.of(context).requestFocus(verificationCodeFocusNode);
      verificationCodeTextFieldController.clear();
      showCodeNotValidErrorMessage = true;
      isVerificationCodeValid = false;
    }
  }

  @override
  void dispose() {
    verificationCodeFocusNode.dispose();
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
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🔑",
                    style: TextStyle(
                      fontFamily: "Tossface",
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildTitle("휴대폰"),
                  buildTitle("본인인증"),
                  const Text(
                    "전화번호를 입력 후, 인증번호를 입력해 주세요.",
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        phoneNumberTextField(),
                        const SizedBox(
                          width: 10,
                        ),
                        sendCodeButton()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  verificationCodeTextField(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: VerificationButton(
        onPressed: () {
          isTimerRunning & isVerificationCodeValid
              ? () {
                  formKey.currentState?.save();
                  onVerifyCodeButtonPressed(
                    phoneNumber: phoneNumber!,
                    verificationCode: verificationCode!,
                  );
                  resetTimer();
                  setState(() {});
                }
              : null;
        },
        text:
            '인증번호 확인 ${isTimerRunning ? secondsToString(secondsRemaining) : ''}',
      ),
    );
  }

  Expanded phoneNumberTextField() {
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: '전화번호',
          hintText: '010XXXXXXXX',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Color(0xFFFF6332),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Color(0xFFFF6332),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorStyle: const TextStyle(
            fontSize: 14,
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        style: const TextStyle(
          fontSize: 17,
        ),
        keyboardType: TextInputType.phone,
        autofocus: true,
        initialValue: '010',
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: phoneNumberValidationString,
        onChanged: (value) {
          isPhoneNumberValid = checkPhoneNumberValid(value);
          setState(() {});
        },
        onSaved: (value) {
          phoneNumber = value;
        },
      ),
    );
  }

  TextButton sendCodeButton() {
    return TextButton(
      onPressed: isPhoneNumberValid ? onSendCodeButtonPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 236, 231),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        '인증번호 전송',
        style: TextStyle(color: Color(0xFFFF6332)),
      ),
    );
  }

  TextFormField verificationCodeTextField() {
    return TextFormField(
      textAlign: TextAlign.center,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: '인증번호',
        hintText: 'XXXXXX',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFFFF6332),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFFFF6332),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorStyle: const TextStyle(
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      style: const TextStyle(
        fontSize: 17,
      ),
      keyboardType: TextInputType.number,
      focusNode: verificationCodeFocusNode,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: verificationCodeValidationString,
      onChanged: (value) {
        isVerificationCodeValid = checkVerificationCodeValid(value);
        setState(() {});
      },
      controller: verificationCodeTextFieldController,
      onSaved: (value) {
        verificationCode = value;
      },
    );
  }
}

Widget buildTitle(text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w800,
    ),
  );
}
