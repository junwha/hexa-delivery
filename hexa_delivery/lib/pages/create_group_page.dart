import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexa_delivery/widgets/buttons.dart';
import 'package:intl/intl.dart';
import 'package:korea_regexp/korea_regexp.dart';

import '../model/thousands_separator.dart';
import '../model/backend.dart' as backend;

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

Widget buiildSubTitle(String icon, String text) {
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
  DateTime? orderDateTimeDateTime;
  String? orderTimeValidaionString;
  bool isOrderTimeValid = false;

  TextEditingController orderDateSelectTextFieldController =
      TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  TextEditingController orderTimeSelectTextFieldController =
      TextEditingController();

  TextEditingController storeNameSelectTextFieldController =
      TextEditingController();

  TextEditingController placeNameSelectTextFieldController =
      TextEditingController();

  List<String> storeNames = [];
  List<String> placeNames = [];

  late String storeName;
  late String orderDate;
  late String orderTime;
  late String orderFee;
  late String placeName;
  late String chatLink;

  Iterable<String> koreanSearch(List<String> data, String query) {
    Iterable<String> ret = data.where((element) {
      String ele = explode(element.toLowerCase()).join();
      String que = explode(query.toLowerCase()).join();
      return ele.contains(que);
    });
    return ret;
  }

  Iterable<String> getStoreNames(String query) {
    return koreanSearch(storeNames, query);
  }

  Iterable<String> getPlaceNames(String query) {
    return koreanSearch(placeNames, query);
  }

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {});
    });

    loadStoreNameSuggestions();
    loadPlaceNameSuggestions();

    super.initState();
  }

  void loadStoreNameSuggestions() async {
    storeNames = await backend.getStoreNames();
  }

  void loadPlaceNameSuggestions() async {
    placeNames = await backend.getPlaceNames();
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
        appBar: AppBar(
          title: const Text('모임 열기'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {}, // 뒤로가기
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
                    buiildSubTitle("🏠", "가계 이름"),
                    storeNameTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    buiildSubTitle("🕰️", "주문 시간"),
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
                    buiildSubTitle("💵", "배달료"),
                    orderFeeTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    buiildSubTitle("🛕", "모이는 장소"),
                    placeNameTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    buiildSubTitle("📱", "오픈채팅방 링크"),
                    chatLinkTextField(),
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
            if (formKey.currentState!.validate() && isOrderTimeValid) {
              formKey.currentState!.save();
              print(
                  '\nstore name: $storeName\norder datetime: $orderDate $orderTime\norder fee: $orderFee\nplace: $placeName\nchat link: $chatLink');
            }
          },
          text: "만둘기",
        ),
      ),
    );
  }

  TextFormField chatLinkTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: '오픈 채팅방 링크를 저장해주세요',
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '오픈 채팅방 링크를 저장해주세요.';
        }
        return null;
      },
      onSaved: (val) {
        setState(() {
          chatLink = val!;
        });
      },
      keyboardType: TextInputType.text,
    );
  }

  TypeAheadFormField<String> placeNameTextField() {
    return TypeAheadFormField(
      noItemsFoundBuilder: (context) => const ListTile(
        title: Text('검색 결과가 없습니다.'),
      ),
      textFieldConfiguration: TextFieldConfiguration(
        controller: placeNameSelectTextFieldController,
        autofocus: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          hintText: '모이는 장소를 선택해주세요',
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '모이는 장소를 선택해주세요.';
        }
        return null;
      },
      onSaved: (val) {
        setState(() {
          placeName = val!;
        });
      },
      suggestionsCallback: getPlaceNames,
      debounceDuration: const Duration(
        milliseconds: 50,
      ),
      animationDuration: Duration.zero,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        placeNameSelectTextFieldController.text = suggestion;
      },
    );
  }

  TextFormField orderFeeTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        prefixIcon: Icon(Icons.attach_money),
        hintText: '배달료를 입력해주세요',
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '배달료를 입력해주세요.';
        }
        return null;
      },
      onSaved: (val) {
        setState(() {
          orderFee = val!.replaceAll(',', '');
        });
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ThousandsSeparatorInputFormatter(),
      ],
    );
  }

  Widget orderTimeValidationString() {
    if (orderDateTimeDateTime == null) {
      isOrderTimeValid = false;
      return const SizedBox();
    }
    Duration timeLeft = orderDateTimeDateTime!.difference(DateTime.now());
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
      onSaved: (val) {
        setState(() {
          orderTime = val!;
        });
      },
      controller: orderTimeSelectTextFieldController,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        );

        if (pickedTime != null) {
          setState(() {
            orderTimeTimeOfDay = pickedTime;
            orderDateTimeDateTime = DateTime(
              orderDateDateTime.year,
              orderDateDateTime.month,
              orderDateDateTime.day,
              orderTimeTimeOfDay!.hour,
              orderTimeTimeOfDay!.minute,
            );
            orderTimeSelectTextFieldController.text =
                pickedTime.format(context); //set the value of text field.
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
      onSaved: (val) {
        setState(() {
          orderDate = val!;
        });
      },
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
            if (orderTimeTimeOfDay != null) {
              orderDateTimeDateTime = DateTime(
                orderDateDateTime.year,
                orderDateDateTime.month,
                orderDateDateTime.day,
                orderTimeTimeOfDay!.hour,
                orderTimeTimeOfDay!.minute,
              );
            }
            orderDateSelectTextFieldController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );
  }

  TypeAheadFormField<String> storeNameTextField() {
    return TypeAheadFormField(
      noItemsFoundBuilder: (context) => const ListTile(
        title: Text('검색 결과가 없습니다.'),
      ),
      textFieldConfiguration: TextFieldConfiguration(
        controller: storeNameSelectTextFieldController,
        autofocus: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          prefixIcon: Icon(
            Icons.search,
            size: 25,
          ),
          hintText: "가계 이름을 입력하세요.",
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '가게 이름을 입력해주세요.';
        }
        return null;
      },
      onSaved: (val) {
        setState(() {
          storeName = val!;
        });
      },
      suggestionsCallback: getStoreNames,
      debounceDuration: const Duration(
        milliseconds: 50,
      ),
      animationDuration: Duration.zero,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        storeNameSelectTextFieldController.text = suggestion;
      },
    );
  }
}
