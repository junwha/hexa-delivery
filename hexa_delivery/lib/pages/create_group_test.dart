import 'package:flutter/material.dart';
import 'package:hexa_delivery/pages/create_group_page.dart';

class CreateGroupPageTest extends StatelessWidget {
  const CreateGroupPageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모임 열기 테스트'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(50),
                    color: const Color(0xffc6edef),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateGroupPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        fixedSize: const Size(250, 60),
                        backgroundColor: const Color(0xff81ccd1),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('모임 열기'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
