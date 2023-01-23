import 'package:flutter/material.dart';

class AuthentificationButton extends StatelessWidget {
  const AuthentificationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('Authentification button pressed');
      }, //본인인증 바로가기
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
      child: const Text('본인인증 바로가기'),
    );
  }
}
