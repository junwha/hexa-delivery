import 'package:flutter/material.dart';
import 'package:hexa_delivery/widgets/Buttons.dart';

void onAuthentificationButtonPressed() {}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
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
                    child: Column(
                      children: const [
                        Text(
                          '휴대폰 본인인증',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Icon(
                          Icons.phone_android_outlined,
                          size: 100,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 240,
                          child: Text(
                            '로그인은 휴대폰 인증을 통해 진행됩니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        VerificationButton(),
                      ],
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
