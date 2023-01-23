import 'package:flutter/material.dart';

class AuthentificationButton extends StatelessWidget {
  const AuthentificationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // 본인인증 바로가기
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff81ccd1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '본인인증 바로가기',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
