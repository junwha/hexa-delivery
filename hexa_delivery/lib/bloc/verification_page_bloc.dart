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

class ButtonStateWithTimer extends ButtonState {
  final Duration _timerDuration;

  ButtonStateWithTimer({
    required timerDuration,
    super.isEnabled,
  }) : _timerDuration = timerDuration;

  Duration get timerDuration => _timerDuration;
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

  final _checkCodeButtonController = StreamController<ButtonStateWithTimer>();
  Stream<ButtonStateWithTimer> get checkCodeButtonStream =>
      _checkCodeButtonController.stream;

  final _timerController = StreamController<Duration>();
  Stream<Duration> get timerStream => _timerController.stream;

  late String? email;
  late String? code;

  static const initialTimerSeconds = 500;

  late UserOnlyUID notVarifiedUser;

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
      _checkCodeButtonController.sink.add(ButtonStateWithTimer(
        isEnabled: false,
        timerDuration: const Duration(seconds: 0),
      ));
    } else if (!RegExp(r'^([0-9]{4})$').hasMatch(text)) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증번호를 입력해 주세요!",
      ));
      _checkCodeButtonController.sink.add(ButtonStateWithTimer(
        isEnabled: false,
        timerDuration: const Duration(seconds: 0),
      ));
    } else {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: null,
      ));
      _checkCodeButtonController.sink.add(ButtonStateWithTimer(
        isEnabled: true,
        timerDuration: const Duration(seconds: 0),
      ));
    }
  }

  void onEmailSaved(String? text) {
    email = text;
  }

  void onCodeSaved(String? text) {
    code = text;
  }

  void onCodeSendButtonPressed() async {
    var login = LoginResource();
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));
    _checkCodeButtonController.sink.add(ButtonStateWithTimer(
      isEnabled: false,
      timerDuration: const Duration(seconds: initialTimerSeconds),
    ));
    _timerController.sink.add(const Duration(
      seconds: initialTimerSeconds,
    ));
    var res = await login.requestCode(email!);
    if (res == null) {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "알 수 없는 오류가 발생했습니다.",
      ));
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: false,
        validationString: null,
      ));
      _checkCodeButtonController.sink.add(ButtonStateWithTimer(
        isEnabled: false,
        timerDuration: const Duration(seconds: 0),
      ));
      _timerController.sink.add(const Duration(
        seconds: 0,
      ));
    } else {
      notVarifiedUser = res;
    }
  }

  void onCheckCodeButtonPressed() async {
    var login = LoginResource();
    var res = await login.checkCode(notVarifiedUser, int.parse(code!));

    if (res.getIsValified()) {
      print(res.getUser().getUID());
      print(res.getUser().getToken());
    } else if (res.getIsCodeExpired()) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증시간이 만료되었습니다. 다시 시도해주세요.",
      ));
    } else if (res.getIsCodeWrong()) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증번호가 틀립니다. 다시 시도해주세요.",
      ));
    } else {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "알 수 없는 오류가 발생했습니다.",
      ));
    }
  }

  void timerExpired() {
    _checkCodeButtonController.sink.add(ButtonStateWithTimer(
      isEnabled: false,
      timerDuration: const Duration(seconds: 0),
    ));
  }

  dispose() {
    _emailTextFieldController.close();
    _codeTextFieldController.close();
    _sendCodeButtonController.close();
    _checkCodeButtonController.close();
    _timerController.close();
  }
}


// ToDo:
//     1. Move FocusNode / Clear TextField -- done
//     2. Exception handling -- done
//     3. ButtonWithTimerState class to ButtonState class
//     4. focusnode and formsave in bloc