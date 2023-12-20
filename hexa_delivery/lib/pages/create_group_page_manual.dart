import 'package:flutter/material.dart';

class CreateGroupPageManual extends StatefulWidget {
  const CreateGroupPageManual({super.key});

  @override
  State<CreateGroupPageManual> createState() => _CreateGroupPageManualState();
}

class _CreateGroupPageManualState extends State<CreateGroupPageManual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 80,
            ),
            child: Column(
              children: [],
            ),
          ),
        ));
  }
}
