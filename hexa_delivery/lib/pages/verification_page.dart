import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resource/login.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final verificationCodeFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  static const initialTimerSeconds = 300;
  int secondsRemaining = initialTimerSeconds;
  bool isTimerRunning = false;
  late Timer timer;
  String? emailAddress;
  String? verificationCode;
  bool isEmailAddressValid = false;
  bool isVerificationCodeValid = false;
  final verificationCodeTextFieldController = TextEditingController();
  String? codeNotValidErrorMessage;
  late Future<UserOnlyUID> userOnlyUIDFuture;
  bool isLoading = false;

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
    formKey.currentState?.save();
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

    var login = LoginResource();
    userOnlyUIDFuture = login.requestCode(emailAddress!);
  }

  String? emailAddressValidationString(value) {
    if (value?.isEmpty ?? true) {
      return '이메일 주소를 입력해주세요.';
    } else if (!RegExp(r'^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
        .hasMatch(value!)) {
      return '이메일 주소를 입력해주세요!';
    } else if (RegExp(r'@unist.ac.kr$').hasMatch(value!)) {
      return '유니스트 이메일은 사용 할 수 없습니다!';
    }
    return null;
  }

  String? verificationCodeValidationString(value) {
    if (codeNotValidErrorMessage != null) {
      return codeNotValidErrorMessage;
    }
    if (value.isEmpty ?? true) {
      return '인증번호를 입력해주세요.';
    } else if (!RegExp(r'^([0-9]{4})$').hasMatch(value!)) {
      return '인증번호를 입력해주세요!';
    }
    return null;
  }

  bool checkEmailAddressValid(value) {
    if (value?.isEmpty ?? true) {
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
        .hasMatch(value!)) {
      return false;
    } else if (RegExp(r'@unist.ac.kr$').hasMatch(value!)) {
      return false;
    }
    return true;
  }

  bool checkVerificationCodeValid(value) {
    if (value.isEmpty ?? true) {
      return false;
    } else if (!RegExp(r'^([0-9]{4})$').hasMatch(value!)) {
      return false;
    }
    return true;
  }

  bool isCodeValid() {
    return verificationCode == '000000';
  }

  void onCodeValid() {
    // Navigator.pop(context);
    print('code valid');
  }

  void onVerifyCodeButtonPressed() async {
    formKey.currentState?.save();
    resetTimer();

    isLoading = true;
    setState(() {});

    var userOnlyUID = await userOnlyUIDFuture;

    var login = LoginResource();

    var userValified =
        await login.checkCode(userOnlyUID, int.parse(verificationCode!));

    if (userValified.getIsValified()) {
      onCodeValid();
    } else if (userValified.getIsCodeExpired()) {
      codeNotValidErrorMessage = '인증번호가 만료되었습니다. 다시 인증해주세요.';
    } else if (userValified.getIsCodeWrong()) {
      codeNotValidErrorMessage = '인증번호가 틀렸습니다. 다시 인증해주세요.';
    } else {
      codeNotValidErrorMessage = '알 수 없는 오류가 발생했습니다. 다시 인증해주세요.';
    }
    isLoading = false;
    setState(() {});
    FocusScope.of(context).requestFocus(verificationCodeFocusNode);
    verificationCodeTextFieldController.clear();
    isVerificationCodeValid = false;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emailAddressTextField(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: sendCodeButton(),
                ),
                const SizedBox(
                  height: 20,
                ),
                verificationCodeTextField(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: checkButton(),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailAddressTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: '이메일',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff81ccd1),
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
        fontSize: 20,
      ),
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      inputFormatters: const [],
      validator: emailAddressValidationString,
      onChanged: (value) {
        isEmailAddressValid = checkEmailAddressValid(value);
        setState(() {});
      },
      onSaved: (value) {
        emailAddress = value;
      },
    );
  }

  TextButton sendCodeButton() {
    return TextButton(
      onPressed: isEmailAddressValid ? onSendCodeButtonPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 30,
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
      child: const Text('인증번호 전송'),
    );
  }

  TextFormField verificationCodeTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: '인증번호',
        hintText: 'XXXX',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff81ccd1),
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
        fontSize: 20,
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

  TextButton checkButton() {
    return TextButton(
      onPressed: isTimerRunning & isVerificationCodeValid
          ? onVerifyCodeButtonPressed
          : null, //본인인증 바로가기
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
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
          '인증번호 확인 ${isTimerRunning ? secondsToString(secondsRemaining) : ''}'),
    );
  }
}
