import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexa_delivery/pages/login_page.dart';
import 'package:hexa_delivery/pages/main_page.dart';
import 'package:hexa_delivery/settings.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  static const storage = FlutterSecureStorage();
  bool isLoaded = false;
  bool isLogin = true;

  void checkLogin() async {
    String? jwtTokenProp = await storage.read(key: kJWTTokenSecureStorageKey);
    String? uidTokenProp = await storage.read(key: kUIDSecureStorageKey);

    if (jwtTokenProp != null && uidTokenProp != null) {
      // validate the token

      isLogin = false;
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() { isLoaded = true; });
    });
    
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded ? routePage() : Scaffold(
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

  Widget routePage() {
    return isLogin ? const LoginPage() : const MainPage();
  }
}