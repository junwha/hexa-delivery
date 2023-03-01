import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../model/thousands_separator.dart';
import '../model/backend.dart' as backend;

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

  Widget buildOrderTimeValidaionString() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임 열기'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Navigator.pop(context);
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
                  const Text(
                    '가게 이름',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: storeNameSelectTextFieldController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.search,
                            size: 40,
                          ),
                        ),
                        hintText: '가게 이름을 입력해주세요',
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
                    suggestionsCallback: backend.getStoreNames,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      storeNameSelectTextFieldController.text = suggestion;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '주문 시간',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '주문 날짜',
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
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          // initialValue: TimeOfDay.now().format(context),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '주문 시간',
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
                                    pickedTime.format(
                                        context); //set the value of text field.
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  buildOrderTimeValidaionString(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '배달료',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 12, right: 12),
                        child: Text('₩',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.grey.shade600,
                            )),
                      ),
                      hintText: '배달료를 입력해주세요',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '모이는 장소',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: placeNameSelectTextFieldController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: '모이는 장소를 선택해주세요',
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
                    suggestionsCallback: backend.getPlaceNames,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      placeNameSelectTextFieldController.text = suggestion;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '오픈 채팅방 링크',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '오픈 채팅방 링크를 저장해주세요',
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              isOrderTimeValid) {
                            formKey.currentState!.save();
                            print(
                                '\nstore name: $storeName\norder datetime: $orderDate $orderTime\norder fee: $orderFee\nplace: $placeName\nchat link: $chatLink');
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
