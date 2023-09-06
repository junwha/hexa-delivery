import 'package:flutter/material.dart';
import 'package:hexa_delivery/pages/main_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import '../bloc/verification_page_bloc.dart';

// void flutterDialog() {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext ctx) {
//       return AlertDialog(
//         content: ,
//       );
//     }
//   );
// }

class VerificationPage extends StatelessWidget {
  final VerificationPageBloc _bloc = VerificationPageBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final codeTextFieldController = TextEditingController();
  final codeFocusNode = FocusNode();
  late final GlobalKey timerKey;

  VerificationPage({super.key});

  @override

  bool CheckUse = false;
  bool CheckPersonalInformation = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증'),
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
                buildTitle("UNIST 이메일 인증"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "unist.ac.kr 메일 주소를 입력한 후,\n인증번호를 확인해주세요.\n",
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
                              hintText: '이메일을 입력해주세요',
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
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              return AlertDialog(
                                                title: Text("약관 동의"),
                                                actions: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 18.0),
                                                        child: TextButton(
                                                          child: Text('개인정보 수집 및 이용 동의서'),
                                                          onPressed: () {
                                                            showDialog(context: context,
                                                            builder: (context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext context, StateSetter setState) {
                                                                  return AlertDialog(
                                                                    
                                                                    title: Text('개인정보 수집 및 이용 동의서'),
                                                                    actions: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsets.all(10.0),
                                                                            child: Container(                                                                              
                                                                              height: 300.0,
                                                                              child: SingleChildScrollView(
                                                                              child: Text('''제1조(개인정보의 처리목적)
                                                                            
< HeXA밥먹어유 >(이)가 개인정보 보호법 제32조에 따라 등록․공개하는 개인정보파일의 처리목적은 다음과 같습니다.

1. 개인정보 파일명 : 밥시켜유 개인정보동의
개인정보의 처리목적 : 사용자 생성 및 관리
수집방법 : 생성정보 수집 툴을 통한 수집
보유근거 : 분쟁 방지
보유기간 : 영구
관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년

제3조(개인정보의 제3자 제공에 관한 사항)

① < HeXA밥먹어유 >은(는) 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.

② < HeXA밥먹어유 >은(는) 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.

1. < 밥시켜유 관리자 >
개인정보를 제공받는 자 : 밥시켜유 관리자
제공받는 자의 개인정보 이용목적 : 이름, 로그인ID, 비밀번호, 휴대전화번호
제공받는 자의 보유.이용기간: 영구
'''),
                                                                            )
                                                                            ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text('확인'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            );
                                                          },
                                                        ),
                                                        // child: Text('개인정보 수집 및 이용 동의서'),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 10.0),
                                                          Checkbox(
                                                            value: CheckUse,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                CheckUse = value!;
                                                              });
                                                            },
                                                          ),
                                                          Text('동의'),
                                                        ],
                                                      ),
                                                      SizedBox(height: 30.0),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 18.0),
                                                        child: TextButton(
                                                          child: Text('밥시켜유 이용약관'),
                                                          onPressed: () {
                                                            showDialog(context: context,
                                                            builder: (context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext context, StateSetter setState) {
                                                                  return AlertDialog(
                                                                    title: Text('밥시켜유 이용약관'),
                                                                    actions: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsets.all(10.0),
                                                                            child: Container(                                                                              
                                                                              height: 300.0,
                                                                              child: SingleChildScrollView(
                                                                              child: Text('''밥먹어유 이용약관

제1조 (목적)

본 약관은 “밥먹어유” 모바일 애플리케이션에서 제공하는 서비스(이하 “서비스”라 함)를 이용함에 있어 “밥먹어유”와 이용자의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.

제2조 (정의)

① “밥먹어유”란 회사가 “서비스”를 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 또는 용역(이하 “재화 등”이라 함)을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 “밥먹어유”를 운영하는 사업자의 의미로도 사용합니다.

② “밥먹어유서비스”란 모바일 애플리케이션을 통해 이용자가 원하는 배달을 다른 사람과 함께 시킬 수 있도록 하는 것을 기본으로 하되 채팅, 모임 생성 등 “밥먹어유” 모바일 애플리케이션 상의 제공 서비스 전체를 의미합니다.

③ “이용자”란 “밥먹어유”에 접속하여 본 약관에 따라 밥먹어유가 제공하는 서비스를 받는 회원을 말합니다.

④ “회원”이라 함은 “밥먹어유”에 개인정보를 제공하여 회원등록을 한 자로서, “밥먹어유”의 정보를 지속적으로 제공받으며, “밥먹어유”가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.

⑤ “가게”란 밥먹어유에서 정보를 제공하는 음식점을 말하며, 회사의 대리인이나 피용자로 간주되지 아니합니다.

⑥ 본 약관에서 정의되지 않은 용어는 관련법령이 정하는 바에 따릅니다.


'''),
                                                                            )
                                                                            ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text('확인'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            );
                                                          },
                                                        ),
                                                        // child: Text('개인정보 수집 및 이용 동의서'),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 10.0),
                                                          Checkbox(
                                                            value: CheckPersonalInformation,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                CheckPersonalInformation = value!;
                                                              });
                                                            },
                                                          ),
                                                          Text('동의'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (CheckUse && CheckPersonalInformation) {
                                                        _formKey.currentState!.save();
                                                        _bloc.onCodeSendButtonPressed();
                                                        // FocusScope.of(context).requestFocus(
                                                        // codeFocusNode); // 작동 안함
                                                        codeTextFieldController.clear();
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("동의하고 시작하기"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      );
                                    }
                                      
                                    : null,
                                child: const Text(
                                  '인증번호 전송',
                                  style: TextStyle(
                                      color: Color(kThemeColorHEX),
                                      fontSize: 13),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
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
