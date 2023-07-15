import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/create_order.dart';
import 'package:hexa_delivery/resources/store_provider.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import 'package:intl/intl.dart';

import '../model/thousands_separator.dart';

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
  bool isStoreNameValid = false;

  late Future<Map<String, int>> rIDFromName;

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

  StoreListQueryProvider storeListQueryProvider = StoreListQueryProvider();
  
  late String storeName;
  late String orderDate;
  late String orderTime;
  late String orderFee;
  late String placeName;
  late String chatLink;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      setState(() {});
    });

    super.initState();
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
                      buiildSubTitle("🚚", "배달의 민족 \"함께주문\" 링크"),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: createGroupButton()),
    );
  }

  TextButton createGroupButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate() && isOrderTimeValid) {
          formKey.currentState!.save();

          var accessToken = "0"; // for testing purposes
          var uid = 1; // for testing purposes
          // TODO(junwha0511): secure storage

          var user = User(uid, accessToken);
          var rID = await rIDFromName.then((value) => value[storeName]);
          var expTime = orderDateTimeDateTime!;
          var fee = int.parse(orderFee);
          var location = placeName;
          var groupLink = chatLink;
          var order =
              OrderToBeCreatedDTO(rID!, expTime, fee, location, groupLink);

          var or = OrderResource();

          or.createOrder(order, user);
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

  TextFormField chatLinkTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: '배달의민족 가게 > 함께주문 > 초대하기 > 링크복사',
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '배달의민족 가게 > 함께주문 > 초대하기 > 링크복사';
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
      suggestionsCallback: (query) {
        return [];
      },
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

  TypeAheadFormField<String?> storeNameTextField() {
    return TypeAheadFormField(
      noItemsFoundBuilder: (context) {
        return const ListTile(
          title: Text('알 수 없는 오류가 발생했습니다.'),
        );
      },
      textFieldConfiguration: TextFieldConfiguration(
        onChanged: (_) {
          isStoreNameValid = false;
        },
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
          hintText: "가게 이름을 입력하세요.",
        ),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '가게를 선택해주세요';
        }
        if (!isStoreNameValid) {
          return '가게를 선택해주세요.';
        }
        return null;
      },
      onSaved: (val) {
        setState(() {
          storeName = val!;
        });
      },
      suggestionsCallback: (query) {
        print("query: $query");

        Future<List<StoreDTO>> searchResultMap = storeListQueryProvider.searchStoresAndGetList(query);
        
        Future<Iterable<String>> storeNameList = searchResultMap.then(
          (storeList) => storeList.map((store) => store.getName));

        return storeNameList;
      },
      debounceDuration: const Duration(
        milliseconds: 300,
      ),
      animationDuration: Duration.zero,
      itemBuilder: (context, suggestion) {
        String text = suggestion ?? "";
        if (suggestion != null && storeListQueryProvider.isCreated(suggestion)) {
          text = "새로운 가게 \"$suggestion\" 추가하기"; 
        }
        return ListTile(
          title: Text(text),
        );
      },
      onSuggestionSelected: (suggestion) {
        isStoreNameValid = true;
        storeNameSelectTextFieldController.text = suggestion ?? "";
      },
    );
  }
}
