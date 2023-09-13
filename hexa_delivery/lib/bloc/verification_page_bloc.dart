import 'dart:async';

import 'package:hexa_delivery/utils/secure_storage_internal.dart';

import '../model/dto.dart';
import '../resources/login_resource.dart';
import 'package:hexa_delivery/settings.dart';

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
  final String _timeRemaining;

  ButtonStateWithTimer({
    required timeRemaining,
    super.isEnabled,
  }) : _timeRemaining = timeRemaining;

  String get timeRemaining => _timeRemaining;
}

class TimerSinker {
  bool _isRunning = false;
  final int _initialTimerSeconds;
  Timer? _timer;
  final StreamController<ButtonStateWithTimer> _streamController;
  final Function() _timerEndCallback;
  int _timerSeconds = 0;
  bool _isEnabled = false;

  TimerSinker({
    required initialTimerSeconds,
    required streamController,
    required timerEndCallback,
  })  : _initialTimerSeconds = initialTimerSeconds,
        _streamController = streamController,
        _timerEndCallback = timerEndCallback,
        _timerSeconds = initialTimerSeconds;

  void startTimer() {
    if (_isRunning) {
      reset();
    }
    _isRunning = true;
    _timerSeconds = _initialTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _addTime());
  }

  void _addTime() {
    const addSeconds = -1;
    _timerSeconds += addSeconds;
    if (_timerSeconds == 0) {
      _timer?.cancel();
      _isRunning = false;
      _timerEndCallback();
    } else {
      _sink();
    }
  }

  void _sink() {
    final minutes = (_timerSeconds / 60).floor();
    final secondsRemainder = _timerSeconds % 60;
    final minutesString = minutes.toString().padLeft(2, '0');
    final secondsString = secondsRemainder.toString().padLeft(2, '0');
    String timeString = '$minutesString:$secondsString';
    if (_timerSeconds == 0) {
      timeString = '';
    }
    _streamController.sink.add(
        ButtonStateWithTimer(isEnabled: _isEnabled, timeRemaining: timeString));
  }

  void disable() {
    _isEnabled = false;
    _sink();
  }

  void enable() {
    _isEnabled = true;
    _sink();
  }

  void reset() {
    _timer?.cancel();
    _timerSeconds = 0;
    _isRunning = false;
  }

  void dispose() {
    _timer?.cancel();
  }
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

  late String? email;
  late String? code;

  static const initialTimerSeconds = 300;

  late UserOnlyUID notVarifiedUser;
  late final TimerSinker _timerSinker;

  bool _isTimerRunning = false;
  bool _isCodeValid = false;

  VerificationPageBloc() {
    _timerSinker = TimerSinker(
      initialTimerSeconds: initialTimerSeconds,
      streamController: _checkCodeButtonController,
      timerEndCallback: onTimerExpired,
    );
  }

  void updateCheckCodeButtonState() {
    if (_isCodeValid && _isTimerRunning) {
      _timerSinker.enable();
    } else {
      _timerSinker.disable();
    }
  }

  void onTimerExpired() {
    _isTimerRunning = false;
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: false,
      validationString: "인증시간이 만료되었습니다. 다시 시도해주세요.",
    ));
    updateCheckCodeButtonState();
  }

  void updateEmailTextField(String text) {
    if (text == kDeliveryTestServerActivator) {
      kDeliveryTestModeOn = true;
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "테스트모드가 활성화되었습니다. 이메일 주소를 입력해 주세요.",
      ));
    } else if (text.isEmpty) {
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
    } else if (!kDeliveryTestModeOn && !RegExp(r'@unist.ac.kr$').hasMatch(text)) {
      _emailTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "유니스트 이메일을 입력해주세요.",
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
      _isCodeValid = false;
      updateCheckCodeButtonState();
    } else if (!RegExp(r'^([0-9]{4})$').hasMatch(text)) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: "인증번호를 입력해 주세요!",
      ));
      _isCodeValid = false;
      updateCheckCodeButtonState();
    } else {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: null,
      ));
      _isCodeValid = true;
      updateCheckCodeButtonState();
    }
  }

  void onEmailSaved(String? text) {
    email = text;
  }

  void onCodeSaved(String? text) {
    code = text;
  }

  void onCodeSendButtonPressed() async {
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));
    _isTimerRunning = false;
    _timerSinker.reset();

    var login = LoginResource();
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
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
    } else {
      notVarifiedUser = res;
      _isTimerRunning = true;
      _timerSinker.startTimer();
      updateCheckCodeButtonState();
    }
  }

  void onCheckCodeButtonPressed() async {
    var login = LoginResource();
    _codeTextFieldController.sink.add(TextFieldState(
      isEnabled: false,
      validationString: null,
    ));
    var res = await login.checkCode(notVarifiedUser, int.parse(code!));

    if (res.getIsValified()) {
      String uid = res.getUser().getUID().toString();
      String token = res.getUser().getToken();
      SecureStorageInternal.writeUserInfoIntoMemoryAndStorage(uid, token);
    } else if (res.getIsCodeExpired()) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: false,
        validationString: "인증시간이 만료되었습니다. 다시 시도해주세요.",
      ));
      _isTimerRunning = false;
      _timerSinker.reset();
      _timerSinker.disable();
    } else if (res.getIsCodeWrong()) {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: false,
        validationString: "인증번호가 틀립니다. 다시 시도해주세요.",
      ));
      _isTimerRunning = false;
      _timerSinker.reset();
      _timerSinker.disable();
    } else {
      _codeTextFieldController.sink.add(TextFieldState(
        isEnabled: false,
        validationString: "알 수 없는 오류가 발생했습니다.",
      ));
      _isTimerRunning = false;
      _timerSinker.reset();
      _timerSinker.disable();
    }
  }

  dispose() {
    _emailTextFieldController.close();
    _codeTextFieldController.close();
    _sendCodeButtonController.close();
    _checkCodeButtonController.close();
    _timerSinker.dispose();
  }
}


// ToDo:
//     1. Move FocusNode / Clear TextField -- done
//     2. Exception handling -- done
//     3. ButtonWithTimerState class to ButtonState class
//     4. focusnode and formsave in bloc