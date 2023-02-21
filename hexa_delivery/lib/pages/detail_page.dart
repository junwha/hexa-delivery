import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final OrderDTO order;

  //DetailPage({super.key});
  const DetailPage(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 204, 209),
        centerTitle: true,
        elevation: 0.0,
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
        child: Column(
          children: <Widget>[
            buildTitleString('가게 이름'),
            buildValueString(order.name),
            buildTitleString('주문 시간'),
            buildValueString("${order.expTime.hour}시 ${order.expTime.minute}분 주문"),
            buildTitleString('픽업 장소'),
            buildValueString(order.meetingLocation),
            buildTitleString('현재 인원'),
            buildValueString('${order.numOfMembers}명'),
            buildTitleString('메뉴 보러가기'),
            buildLinkedButton(order.menuLink),
            buildParticipateButton(order.groupLink),
          ],
        ),
      ),
    );
  }
}
Center buildParticipateButton(String link) {
  return Center(
    child: Container(
        width: 315,
        height: 94,
        margin: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: () {
            launchUrl(Uri.parse(link));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 129, 204, 209),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
              elevation: 0.0),
          child: const Text(
            '참여하기',
            style: TextStyle(fontSize: 32, color: Colors.black),
          ),
          
        ),
    ),
  );
}

Widget buildLinkedButton(String link) {
  return Container(
      alignment: const Alignment(-1.0, -1.0),
      //color: Colors.blue,
      margin: const EdgeInsets.only(left: 39),
      child: TextButton(
          onPressed: () {
            launchUrl(Uri.parse(link));
          },
          child: Text(link,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.underline))),
      );
}

Widget buildTitleString(String content) {
  return Container(
      alignment: const Alignment(-1.0, -1.0),
      margin: const EdgeInsets.only(left: 36, top: 15),
      child: Text(content, style: const TextStyle(fontSize: 24, color: Colors.grey)),
  );
}

Widget buildValueString(String content) {
  return Container(
      alignment: const Alignment(-1.0, -1.0),
      margin: const EdgeInsets.only(left: 39),
      child: Text(content, style: const TextStyle(fontSize: 32)),
  );
}

