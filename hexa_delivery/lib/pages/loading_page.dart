import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("HeXA\nDelivery", style: kHighlightTextStyle)),
          const SizedBox(height: 30),
          const LinearProgressIndicator(
            backgroundColor: Color(kThemeColorHEX),
            color: Colors.white,
            minHeight: 10,
          ),        
          ],
      ),
    );
  }
}