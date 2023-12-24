import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/order_resource.dart';
import 'package:hexa_delivery/resources/store_resource.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

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

class TimerTextState {
  final String _text;
  final bool _isEmphasized;

  TimerTextState({
    required text,
    required isEmphasized,
  })  : _text = text,
        _isEmphasized = isEmphasized;

  String get text => _text;
  bool get isEmphasized => _isEmphasized;
}

class CreateGroupPageBloc {
  late final BuildContext context;
  final _formKey = GlobalKey<FormState>();
  late final StoreDTO store;
  late String? link;
  DateTime? deliveryTime;
  int orderFee = 0;
  String orderPlace = '';
  String? deliveryTimeValidationString;
  StoreResource storeResource = StoreResource();

  GlobalKey<FormState> get formKey => _formKey;

  final _storeNameTextFieldStreamController =
      StreamController<TextFieldState>();
  Stream<TextFieldState> get storeNameTextFieldStream =>
      _storeNameTextFieldStreamController.stream;
  final _storeNameTextFieldController = TextEditingController();
  TextEditingController get storeNameTextFieldController =>
      _storeNameTextFieldController;

  final _linkTextFieldStreamController = StreamController<TextFieldState>();
  Stream<TextFieldState> get linkTextFieldStream =>
      _linkTextFieldStreamController.stream;
  final _linkTextFieldController = TextEditingController();
  TextEditingController get linkTextFieldController => _linkTextFieldController;

  final _orderTimeTextFieldStreamController =
      StreamController<TextFieldState>();
  Stream<TextFieldState> get orderTimeTextFieldStream =>
      _orderTimeTextFieldStreamController.stream;
  final _orderTimeTextFieldController = TextEditingController();
  TextEditingController get orderTimeTextFieldController =>
      _orderTimeTextFieldController;

  final _orderTimeRemainingTextStreamController =
      StreamController<TimerTextState>();
  Stream<TimerTextState> get orderTimeRemainingTextStream =>
      _orderTimeRemainingTextStreamController.stream;

  final _orderFeeTextFieldStreamController = StreamController<TextFieldState>();
  Stream<TextFieldState> get orderFeeTextFieldStream =>
      _orderFeeTextFieldStreamController.stream;
  final _orderFeeTextFieldController = TextEditingController();
  TextEditingController get orderFeeTextFieldController =>
      _orderFeeTextFieldController;

  final _orderPlaceTextFieldStreamController =
      StreamController<TextFieldState>();
  Stream<TextFieldState> get orderPlaceTextFieldStream =>
      _orderPlaceTextFieldStreamController.stream;
  final _orderPlaceTextFieldController = TextEditingController();
  TextEditingController get orderPlaceTextFieldController =>
      _orderPlaceTextFieldController;

  final _createGroupButtonStreamController = StreamController<ButtonState>();
  Stream<ButtonState> get createGroupButtonStream =>
      _createGroupButtonStreamController.stream;

  CreateGroupPageBloc({
    required this.store,
    this.link,
    required this.context,
  }) {
    _storeNameTextFieldController.text = store.name;
    _storeNameTextFieldStreamController.sink.add(TextFieldState(
      isEnabled: false,
      validationString: null,
    ));

    if (link != null) {
      _linkTextFieldController.text = link!;
      _linkTextFieldStreamController.sink.add(TextFieldState(
        isEnabled: false,
        validationString: null,
      ));
    } else {
      _linkTextFieldController.text = '';
      _linkTextFieldStreamController.sink.add(TextFieldState(
        isEnabled: true,
        validationString: null,
      ));
    }

    _orderTimeTextFieldStreamController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));

    _orderFeeTextFieldStreamController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));

    _orderPlaceTextFieldStreamController.sink.add(TextFieldState(
      isEnabled: true,
      validationString: null,
    ));
  }

  String? _storeNameTextFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "가게 이름을 입력해 주세요.";
    } else {
      return null;
    }
  }

  String? Function(String?) get storeNameTextFieldValidator =>
      _storeNameTextFieldValidator;

  String? _linkTextFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "가게 링크를 입력해 주세요.";
    } else if (!RegExp(r'^https://s\.baemin\.com/\w{3}\.\w{5}$')
        .hasMatch(text)) {
      return "배달의 민족 링크를 다시 확인해주세요.";
    } else {
      return null;
    }
  }

  String? Function(String?) get linkTextFieldValidator =>
      _linkTextFieldValidator;

  String? _orderTimeTextFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "주문할 시간을 입력해 주세요.";
    } else if (deliveryTimeValidationString != null) {
      return deliveryTimeValidationString;
    } else {
      return null;
    }
  }

  String? Function(String?) get orderTimeTextFieldValidator =>
      _orderTimeTextFieldValidator;

  String? _orderFeeTextFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "배달비를 입력해 주세요.";
    } else {
      return null;
    }
  }

  String? Function(String?) get orderFeeTextFieldValidator =>
      _orderFeeTextFieldValidator;

  String? _orderPlaceTextFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "배달 장소를 입력해 주세요.";
    } else {
      return null;
    }
  }

  String? Function(String?) get orderPlaceTextFieldValidator =>
      _orderPlaceTextFieldValidator;

  void onOrderTimeSelected(TimeOfDay? time) {
    if (time == null) {
      _orderTimeTextFieldController.text = '';
    } else {
      final now = TimeOfDay.now();
      final currentTime = DateTime.now();
      final selectedTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        time.hour,
        time.minute,
      );

      if (time.hour < now.hour ||
          (time.hour == now.hour && time.minute <= now.minute)) {
        deliveryTime = selectedTime.add(const Duration(days: 1));
      } else {
        deliveryTime = selectedTime;
      }

      int hour = deliveryTime!.hour;
      String meridiem = '오전';
      if (hour >= 12) {
        meridiem = '오후';
        if (hour > 12) {
          hour -= 12;
        }
      }
      _orderTimeTextFieldController.text =
          "${deliveryTime!.month}월 ${deliveryTime!.day}일 $meridiem $hour시 ${deliveryTime!.minute}분";
    }
  }

  void updateRemainingTimeText() {
    String? remainingText;
    bool isEmphasized = false;

    if (deliveryTime == null) {
      remainingText = null;
      isEmphasized = false;
    } else {
      final now = DateTime.now();
      if (now.isAfter(deliveryTime!)) {
        deliveryTimeValidationString = "주문 시간이 지났습니다.";
        _formKey.currentState!.validate();
      } else {
        deliveryTimeValidationString = null;
        _formKey.currentState!.validate();
        final difference = deliveryTime!.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes - hours * 60;
        final seconds = difference.inSeconds - hours * 3600 - minutes * 60;
        remainingText = "주문 시간까지 $hours시간 $minutes분 $seconds초 남았습니다.";
        isEmphasized = difference.inMinutes < 10;
      }
    }

    final timerTextState = TimerTextState(
      text: remainingText ?? '',
      isEmphasized: isEmphasized,
    );
    _orderTimeRemainingTextStreamController.sink.add(timerTextState);
  }

  void updateCreateGroupButtonEnablity() {
    final isValid = _formKey.currentState?.validate();
    if (isValid ?? false) {
      _createGroupButtonStreamController.sink.add(ButtonState(
        isEnabled: true,
      ));
    } else {
      _createGroupButtonStreamController.sink.add(ButtonState(
        isEnabled: false,
      ));
    }
  }

  void onStoreNameSaved(String? text) {}

  void onLinkSaved(String? text) {
    link = text!;
  }

  void onOrderTimeSaved(String? text) {}

  void onOrderFeeSaved(String? text) {
    orderFee = int.parse(text?.replaceAll(',', '') ?? '0');
  }

  void onOrderPlaceSaved(String? text) {
    orderPlace = text ?? '';
  }

  void onCreateGroupButtonPressed() async {
    formKey.currentState?.save();

    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: kThemeData.primaryColor,
              ),
            ),
          ],
        );
      },
    );

    var orderResource = OrderResource();

    print('${store.name} $orderFee $orderPlace ${link!} ${deliveryTime!}');
    var isSuccessful = await orderResource.createOrder(
      storeDTO: store,
      fee: orderFee,
      location: orderPlace,
      groupLink: link!,
      time: deliveryTime!,
    );

    if (isSuccessful) {
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "오류",
              style: TextStyle(
                fontFamily: 'Tossface',
                fontSize: 20,
              ),
            ),
            content: const Text(
              "주문 생성에 실패했습니다.",
              style: TextStyle(
                fontFamily: 'Tossface',
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "확인",
                  style: TextStyle(
                    fontFamily: 'Tossface',
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void onTimerTick() {
    updateRemainingTimeText();
    updateCreateGroupButtonEnablity();
  }

  void dispose() {
    _storeNameTextFieldStreamController.close();
    _linkTextFieldStreamController.close();
    _orderTimeTextFieldStreamController.close();
    _orderTimeRemainingTextStreamController.close();
    _orderFeeTextFieldStreamController.close();
    _orderPlaceTextFieldStreamController.close();
    _createGroupButtonStreamController.close();
  }
}
