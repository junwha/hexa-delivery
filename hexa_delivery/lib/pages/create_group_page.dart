import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexa_delivery/model/token_and_uid.dart';
import 'package:hexa_delivery/resource/create_order.dart';
import 'package:hexa_delivery/resource/store_provider.dart';
import 'package:intl/intl.dart';

import '../model/dto.dart';
import '../model/thousands_separator.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
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
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '가게 이름',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    storeNameTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '주문 시간',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 5,
                    ),
                    orderTimeValidationString(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '배달료',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    orderFeeTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '모이는 장소',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    placeNameTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '오픈 채팅방 링크',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    chatLinkTextField(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createGroupButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextButton createGroupButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate() && isOrderTimeValid) {
          formKey.currentState!.save();

          var accessToken = UserInfo.accessToken; // for testing purposes
          var uid = UserInfo.uID; // for testing purposes

          var user = User(accessToken, uid);
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
        fixedSize: const Size(250, 60),
        backgroundColor: const Color(0xff81ccd1),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('만들기'),
    );
  }

  TextFormField chatLinkTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: '오픈 채팅방 링크를 저장해주세요',
      ),
      style: const TextStyle(
        fontSize: 20,
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
          fontSize: 20,
        ),
        decoration: const InputDecoration(
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
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
          child: Text('₩',
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey.shade600,
              )),
        ),
        hintText: '배달료를 입력해주세요',
      ),
      style: const TextStyle(
        fontSize: 20,
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
      return const SizedBox(
        width: double.infinity,
        child: Text(
          '주문시간을 입력해주세요.',
          textAlign: TextAlign.end,
        ),
      );
    }
    Duration timeLeft = orderDateTimeDateTime!.difference(DateTime.now());
    if (timeLeft.isNegative) {
      isOrderTimeValid = false;
      return const SizedBox(
        width: double.infinity,
        child: Text(
          '주문 시간이 현재 시간보다 이릅니다.',
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    if (timeLeft.inMinutes < 10) {
      isOrderTimeValid = true;
      return const SizedBox(
        width: double.infinity,
        child: Text(
          '남은 시간이 10분 미만입니다.',
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    isOrderTimeValid = true;
    return SizedBox(
      width: double.infinity,
      child: Text(
        '${timeLeft.inMinutes}분 남았습니다.',
        textAlign: TextAlign.end,
      ),
    );
  }

  TextFormField orderTimeTextField(BuildContext context) {
    return TextFormField(
      // initialValue: TimeOfDay.now().format(context),
      readOnly: true,
      decoration: const InputDecoration(
        hintText: '주문 시간',
      ),
      style: const TextStyle(
        fontSize: 20,
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
      ),
      style: const TextStyle(
        fontSize: 20,
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
          title: Text('검색 결과가 없습니다.'),
        );
      },
      textFieldConfiguration: TextFieldConfiguration(
        onChanged: (_) {
          isStoreNameValid = false;
        },
        controller: storeNameSelectTextFieldController,
        autofocus: true,
        style: const TextStyle(
          fontSize: 20,
        ),
        decoration: const InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.search,
              size: 40,
            ),
          ),
          hintText: '가게 이름을 입력해주세요',
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
        var provider = StoreListQueryProvider();

        var q = provider.searchStores(query);

        rIDFromName = q.then((stores) {
          return {for (var store in stores) store.getName(): store.getRID()};
        });

        var ret = q.then((stores) {
          return stores.map((store) => store.getName()).toList();
        });

        return ret;
      },
      debounceDuration: const Duration(
        milliseconds: 300,
      ),
      animationDuration: Duration.zero,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion ?? ""),
        );
      },
      onSuggestionSelected: (suggestion) {
        isStoreNameValid = true;
        storeNameSelectTextFieldController.text = suggestion ?? "";
      },
    );
  }
}
