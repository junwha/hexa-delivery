import 'package:flutter/material.dart';
import 'package:hexa_delivery/theme/theme_data.dart' as theme;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: _bloc.emailTextFieldStream,
                  builder: (context, textStream) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: '이메일',
                        hintText: '유니스트 이메일은 사용 할 수 없습니다.',
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
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: _bloc.sendCodeButtonStream,
                  builder: (context, stream) {
                    return SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: theme.textButtonDefaultStyle,
                        onPressed:
                            (stream.hasData ? stream.data!.isEnabled : false)
                                ? () {
                                    _formKey.currentState!.save();
                                    _bloc.onCodeSendButtonPressed();
                                    FocusScope.of(context)
                                        .requestFocus(codeFocusNode); // 작동 안함
                                    codeTextFieldController.clear();
                                  }
                                : null,
                        child: const Text('인증번호 전송'),
                      ),
                    );
                  },
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
                StreamBuilder(
                  stream: _bloc.checkCodeButtonStream,
                  builder: (context, stream) {
                    // timerKey = GlobalKey();
                    return SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: theme.textButtonDefaultStyle,
                        onPressed:
                            (stream.hasData ? stream.data!.isEnabled : false)
                                ? () {
                                    _formKey.currentState!.save();
                                    _bloc.onCheckCodeButtonPressed();
                                  }
                                : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('인증번호 확인'),
                            if (stream.hasData
                                ? (stream.data!.timeRemaining != '')
                                : false)
                              Text(stream.data!.timeRemaining),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
