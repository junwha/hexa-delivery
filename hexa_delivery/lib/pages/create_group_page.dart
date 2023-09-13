import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/order_resource.dart';
import 'package:hexa_delivery/resources/store_resource.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import 'package:intl/intl.dart';

import '../model/thousands_separator.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

Widget buildSubTitle(String icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          icon,
          style: const TextStyle(
            fontFamily: 'Tossface',
            fontSize: 20,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: const TextStyle(
              color: Colors.black45, fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

Widget buildTimeLeftText(int leftTime) {
  final int hour = leftTime ~/ 60;
  final int min = leftTime % 60;
  String text = "";
  if (hour != 0) {
    text += '$hour시간';
  }
  text += '$min분 남았습니다.';
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Text(
      text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black54,
        fontSize: 12,
      ),
    ),
  );
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final formKey = GlobalKey<FormState>();
  late Timer timer;

  DateTime orderDateDateTime = DateTime.now();
  TimeOfDay? orderTimeTimeOfDay;
  String? orderTimeValidaionString;
  bool isOrderTimeValid = false;
  bool isStoreNameValid = false;

  TextEditingController orderDateSelectTextFieldController =
      TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  TextEditingController orderTimeSelectTextFieldController =
      TextEditingController();

  TextEditingController storeNameSelectTextFieldController =
      TextEditingController();

  TextEditingController storeCategorySelectTextFieldController =
      TextEditingController();

  TextEditingController placeNameSelectTextFieldController =
      TextEditingController();

  // This resource will control all of communications
  OrderResource orderResource = OrderResource();

  final TextEditingController _chatLinkController = TextEditingController();

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {});
    });

    super.initState();

    _chatLinkController.addListener(() {
      final text = _chatLinkController.text;
      var formattedText = text.replaceAll(RegExp(r'[^a-zA-Z0-9/:?&=.]*'), '');
      formattedText = text.replaceAll(RegExp(r'^[^a-zA-Z]+'), '');
      if (text != formattedText) {
        _chatLinkController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('모임 열기'),
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
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSubTitle("🏠", "가게 이름"),
                      storeNameTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildCategoryField(),
                      buildSubTitle("🕰️", "주문 시간"),
                      Row(
                        children: [
                          Expanded(
                            child: orderDateTextField(context),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: orderTimeTextField(context),
                          ),
                        ],
                      ),
                      orderTimeValidationString(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildSubTitle("💵", "배달료"),
                      orderFeeTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildSubTitle("🛕", "모이는 장소"),
                      placeNameTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      buildSubTitle("🚚", "배달의 민족 \"함께주문\" 링크"),
                      chatLinkTextField(),
                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: createGroupButton(context)),
    );
  }

  Widget buildCategoryField() {
    if (orderResource.storeDTO is StoreCreateDTO) {
      return Column(
        children: [
          buildSubTitle("🍗", "카테고리"),
          storeCategoryTextField(),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  TextButton createGroupButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        print(formKey.currentState!.validate());
        if (formKey.currentState!.validate() && isOrderTimeValid) {
          formKey.currentState!.save();
          orderResource.createOrder().then((result) => {
                // TODO: toast message (success or unsucess)
                if (result) {Navigator.pop(context)}
              });
        }
      },
      style: TextButton.styleFrom(
        fixedSize: const Size(330, 50),
        backgroundColor: const Color(kThemeColorHEX),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "모임열기",
        style: TextStyle(fontWeight: FontWeight.w800, fontFamily: "Spoqa"),
      ),
    );
  }

  TextFormField buildOCTextField({
    TextEditingController? controller,
    required String hintText,
    required Function(String?) onSaved,
    Icon? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        prefixIcon: prefixIcon,
        hintText: hintText,
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return hintText;
        }

        if (validator != null) {
          String? validationError = validator(val);
          return validationError;
        }

        return null;
      },
      onSaved: onSaved,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
    );
  }

  TextFormField chatLinkTextField() {
    RegExp regex =
        RegExp(r'^(http|https):\/\/(www\.)?baemin\.com.*order.*group.*');

    return buildOCTextField(
      controller: _chatLinkController,
      hintText: '배달의민족 가게 > 함께주문 > 초대하기 > 링크복사',
      onSaved: (val) {
        orderResource.groupLink = val!;
      },
      validator: (String? val) {
        if ((val == null) || !regex.hasMatch(val)) {
          return '유효한 URL을 입력해주세요.';
        }
        return null;
      },
    );
  }

  TextFormField placeNameTextField() {
    return buildOCTextField(
      hintText: '예) 1차 기숙사 광장, 경영관 1층',
      onSaved: (val) {
        orderResource.location = val!;
      },
    );
  }

  TextFormField orderFeeTextField() {
    return buildOCTextField(
      hintText: '배달료를 입력해주세요',
      prefixIcon: const Icon(Icons.attach_money),
      onSaved: (val) {
        orderResource.fee = int.parse(val!.replaceAll(',', ''));
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsSeparatorInputFormatter(),
      ],
    );
  }

  Widget orderTimeValidationString() {
    Duration timeLeft = orderResource.expTime.difference(DateTime.now());
    if (timeLeft.isNegative) {
      isOrderTimeValid = false;
      return const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            '주문 시간이 현재 시간보다 이릅니다.',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    if (timeLeft.inMinutes < 10) {
      isOrderTimeValid = true;
      return const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            '남은 시간이 10분 미만입니다.',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    isOrderTimeValid = true;
    return SizedBox(
      width: double.infinity,
      child: buildTimeLeftText(timeLeft.inMinutes),
    );
  }

  TextFormField orderTimeTextField(BuildContext context) {
    return TextFormField(
      // initialValue: TimeOfDay.now().format(context),
      readOnly: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        hintText: '주문 시간',
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '주문 시간을 입력해주세요.';
        }
        return null;
      },
      onSaved: (val) {},
      controller: orderTimeSelectTextFieldController,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        );

        if (pickedTime != null) {
          setState(() {
            orderTimeTimeOfDay = pickedTime;
            orderTimeSelectTextFieldController.text =
                pickedTime.format(context); //set the value of text field.
            orderResource.expTime = DateTime(
              orderResource.expTime.year,
              orderResource.expTime.month,
              orderResource.expTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          });
        }
      },
    );
  }

  TextFormField orderDateTextField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        hintText: '주문 날짜',
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '주문 날짜를 입력해주세요.';
        }
        return null;
      },
      onSaved: (val) {},
      controller: orderDateSelectTextFieldController,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(), //get today's date
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(
              days: 1,
            ),
          ),
        );

        if (pickedDate != null) {
          setState(() {
            orderDateDateTime = pickedDate;
            orderDateSelectTextFieldController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate);
            orderResource.expTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              orderResource.expTime.hour,
              orderResource.expTime.minute,
            );
          });
        }
      },
    );
  }

  TypeAheadFormField<T> buildOCTypeAheadFormField<T>({
    required String hintText,
    required Widget Function(BuildContext, dynamic) itemBuilder,
    required TextEditingController? controller,
    required FutureOr<Iterable<T>> Function(String) suggestionsCallback,
    required void Function(T) onSuggestionSelected,
    Widget Function(BuildContext)? noItemsFoundBuilder,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
  }) {
    return TypeAheadFormField<T>(
      noItemsFoundBuilder: noItemsFoundBuilder ??
          (context) {
            return const ListTile(
              title: Text('알 수 없는 오류가 발생했습니다.'),
            );
          },
      textFieldConfiguration: TextFieldConfiguration(
        onChanged: onChanged,
        controller: controller,
        autofocus: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
          ),
          hintText: hintText,
        ),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (val) {
        if (val == null || val.isEmpty) return hintText;
        return null;
      },
      onSaved: onSaved,
      suggestionsCallback: suggestionsCallback,
      debounceDuration: const Duration(
        milliseconds: 300,
      ),
      animationDuration: Duration.zero,
      itemBuilder: itemBuilder,
      onSuggestionSelected: onSuggestionSelected,
    );
  }

  TypeAheadFormField<dynamic> storeNameTextField() {
    return buildOCTypeAheadFormField(
      itemBuilder: (context, suggestion) {
        String text = suggestion == null ? "" : suggestion.getName;
        if (suggestion != null && suggestion is StoreCreateDTO) {
          text = "새로운 가게 \"${suggestion.getName}\" 추가하기";
        }
        return ListTile(
          title: Text(text),
        );
      },
      controller: storeNameSelectTextFieldController,
      hintText: "가게 이름을 입력하세요.",
      suggestionsCallback: (query) {
        print("query: $query");

        return StoreResource.getStoreList(query);
      },
      onSuggestionSelected: (suggestion) {
        isStoreNameValid = true;
        storeNameSelectTextFieldController.text =
            suggestion == null ? "" : suggestion.getName;
        orderResource.storeDTO = suggestion;
      },
    );
  }

  TypeAheadFormField<String> storeCategoryTextField() {
    return buildOCTypeAheadFormField(
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion ?? ""),
        );
      },
      noItemsFoundBuilder: (context) {
        return const ListTile(
          title: Text('카테고리가 존재하지 않습니다'),
        );
      },
      controller: storeCategorySelectTextFieldController,
      hintText: "카테고리를 선택하세요",
      suggestionsCallback: (query) {
        return kCategoryList.map((c) => c["Name"]);
      },
      onSuggestionSelected: (suggestion) {
        isStoreNameValid = true;
        storeCategorySelectTextFieldController.text = suggestion;
        if (orderResource.storeDTO is StoreCreateDTO) {
          (orderResource.storeDTO as StoreCreateDTO).category = suggestion;
        }
      },
    );
  }
}
