import 'dart:async';

import '../model/dto.dart';
import '../resource/login.dart';

class TextFieldState {
  final bool _isEnabled;
  final String? _validationString;

  TextFieldState({
    required isEnabled,
    required validationString,
  })  : _isEnabled = isEnabled,
        _validationString = validationString;

  String? get validationString => _validationString;
  bool get isEnabled => _isEnabled;
}

class ButtonState {
  final bool _isEnabled;

  ButtonState({
    required isEnabled,
  }) : _isEnabled = isEnabled;

  bool get isEnabled => _isEnabled;
}

class VerificationPageBloc {
  final _emailTextFieldController = StreamController<TextFieldState>();
  Stream<TextFieldState> get emailTextFieldStream =>
      _emailTextFieldController.stream;

  final _sendCodeButtonController = StreamController<ButtonState>();
  Stream<ButtonState> get sendCodeButtonStream =>
      _sendCodeButtonController.stream;

  final _codeTextFieldController = StreamController<TextFieldState>();
  Stream<TextFieldState> get codeTextFieldStream =>
      _codeTextFieldController.stream;

  final _checkCodeButtonController = StreamController<ButtonState>();
  Stream<ButtonState> get checkCodeButtonStream =>
      _checkCodeButtonController.stream;

  final _timerVisibleController = StreamController<Duration>();
  Stream<Duration> get timerVisibleController => _timerVisibleController.stream;

  late String? email;
  late String? code;

  static const initialTimerSeconds = 600;
  int secondsRemaining = initialTimerSeconds;
  bool isTimerRunning = false;
  late Timer timer;

  late Future<UserOnlyUID> notVarifiedUser;

  void updateEmailTextField(String text) {
    if (text.isEmpty) {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "이메일 주소를 입력해 주세요.",
      ));
      _sendCodeButtonController.sink.add(ButtonState(
        isEnabled: false,
      ));
    } else if (!RegExp(r'^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
        .hasMatch(text)) {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "이메일 주소를 입력해 주세요!",
      ));
      _sendCodeButtonController.sink.add(ButtonState(
        isEnabled: false,
      ));
    } else if (RegExp(r'@unist.ac.kr$').hasMatch(text)) {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "유니스트 이메일은 사용 할 수 없습니다.",
      ));
      _sendCodeButtonController.sink.add(ButtonState(
        isEnabled: false,
      ));
    } else {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: null,
      ));
      _sendCodeButtonController.sink.add(ButtonState(
        isEnabled: true,
      ));
    }
  }

  void updateCodeTextField(String text) {
    if (text.isEmpty) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증번호를 입력해 주세요.",
      ));
      _checkCodeButtonController.sink.add(ButtonState(
        isEnabled: false,
      ));
    } else if (!RegExp(r'^([0-9]{4})$').hasMatch(text)) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증번호를 입력해 주세요!",
      ));
      _checkCodeButtonController.sink.add(ButtonState(
        isEnabled: false,
      ));
    } else {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: null,
      ));
      _checkCodeButtonController.sink.add(ButtonState(
        isEnabled: true,
      ));
    }
  }

  void onEmailSaved(String? text) {
    email = text;
  }

  void onCodeSaved(String? text) {
    code = text;
  }

  void onCodeSendButtonPressed() {
    var login = LoginResource();
    notVarifiedUser = login.requestCode(email!);
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));
    _checkCodeButtonController.sink.add(ButtonState(isEnabled: true));
    _timerVisibleController.add(const Duration(seconds: 300));
  }

  void onCheckCodeButtonPressed() {}

  dispose() {
    _emailTextFieldController.close();
    _codeTextFieldController.close();
    _sendCodeButtonController.close();
    _checkCodeButtonController.close();
    _timerVisibleController.close();
  }
}


// ToDo:
//     1. Move FocusNode / Clear TextField
//     2. Exception handling