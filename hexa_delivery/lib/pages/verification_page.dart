import 'package:flutter/material.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import '../bloc/verification_page_bloc.dart';

class VerificationPage extends StatelessWidget {
  final VerificationPageBloc _bloc = VerificationPageBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final codeTextFieldController = TextEditingController();
  final codeFocusNode = FocusNode();
  late GlobalKey timerKey;

  VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴대폰 본인인증'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🔑",
                  style: TextStyle(
                    fontFamily: "Tossface",
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTitle("휴대폰"),
                buildTitle("본인인증"),
                const Text(
                  "이메일 주소 입력 후, 인증번호를 입력해 주세요.",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: _bloc.emailTextFieldStream,
                      builder: (context, textStream) {
                        return Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: '이메일',
                              hintText: '유니스트 이메일 사용 불가',
                              errorText: textStream.hasData
                                  ? textStream.data!.validationString
                                  : null,
                            ),
                            enabled: textStream.hasData
                                ? textStream.data!.isEnabled
                                : true,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            onChanged: (String text) {
                              _bloc.updateEmailTextField(text);
                            },
                            onSaved: _bloc.onEmailSaved,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        StreamBuilder(
                          stream: _bloc.sendCodeButtonStream,
                          builder: (context, stream) {
                            return SizedBox(
                              height: 60,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 236, 231),
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: (stream.hasData
                                        ? stream.data!.isEnabled
                                        : false)
                                    ? () {
                                        _formKey.currentState!.save();
                                        _bloc.onCodeSendButtonPressed();
                                        FocusScope.of(context).requestFocus(
                                            codeFocusNode); // 작동 안함
                                        codeTextFieldController.clear();
                                      }
                                    : null,
                                child: const Text(
                                  '인증번호 전송',
                                  style: TextStyle(
                                      color: Color(kThemeColorHEX), fontSize: 13),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: _bloc.codeTextFieldStream,
                  builder: (context, textStream) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: '인증번호',
                        hintText: 'XXXX',
                        errorText: textStream.hasData
                            ? textStream.data!.validationString
                            : null,
                        errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                      focusNode: codeFocusNode,
                      controller: codeTextFieldController,
                      enabled: textStream.hasData
                          ? textStream.data!.isEnabled
                          : false,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      onChanged: (String text) =>
                          _bloc.updateCodeTextField(text),
                      onSaved: _bloc.onCodeSaved,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
        stream: _bloc.checkCodeButtonStream,
        builder: (context, stream) {
          // timerKey = GlobalKey();
          return Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                backgroundColor: const Color(kThemeColorHEX),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              onPressed: (stream.hasData ? stream.data!.isEnabled : false)
                  ? () {
                      _formKey.currentState!.save();
                      _bloc.onCheckCodeButtonPressed();
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '인증번호 확인',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  if (stream.hasData
                      ? (stream.data!.timeRemaining != '')
                      : false)
                    const SizedBox(width: 5),
                  stream.data == null
                      ? const Text("")
                      : Text(
                          stream.data!.timeRemaining,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildTitle(text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w800,
    ),
  );
}
