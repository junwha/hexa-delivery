import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexa_delivery/pages/verification_page.dart';
import 'package:hexa_delivery/widgets/buttons.dart';

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
            Navigator.pop(context);
          }, // 뒤로가기
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                buildTitle("휴대폰"),
                buildTitle("본인인증"),
                const SizedBox(height: 10),
                buildSubText("로그인은 휴대폰"),
                buildSubText("방식으로 진행됩니다."),
                const SizedBox(height: 50),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/phone.svg",
                    height: 250,
                  ),
                ),
                const SizedBox(height: 20),
                Center(child: buildExampleTextBox())
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: VerificationButton(
        text: "본인인증 바로가기",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VerificationPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget buildTitle(text) {
  return Text(
    text,
    style: const TextStyle(
        color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 30),
  );
}

Widget buildSubText(text) {
  return Text(
    text,
    style: const TextStyle(color: Colors.black26, fontSize: 15),
  );
}

Widget buildExampleTextBox() {
  return Container(
    width: 300,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    decoration: const BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.all(Radius.circular(15))),
    child:
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "HeXA Delivery",
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 15),
      ),
      SizedBox(height: 5),
      Text(
        "HexaDelivery의 인증번호는 OOOO번 입니다. 타인에게 노출하지 마세요.",
        style: TextStyle(color: Colors.black54),
      ),
    ]),
  );
}
