import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  OrderDTO order;

  //DetailPage({super.key});
  DetailPage(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.name,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 129, 204, 209),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            print('clicked');
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
            participationButton(order.groupLink),
          ],
        ),
      ),
    );
  }

  Center participationButton(String link) {
    return Center(
      child: Container(
          //color: Colors.red,
          width: 315,
          height: 94,
          child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(link));
            },
            child: Text(
              '참여하기',
              style: TextStyle(fontSize: 32, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 129, 204, 209),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                elevation: 0.0),
          ),
          margin: EdgeInsets.only(top: 10)),
    );
  }

  Widget buildLinkedButton(String link) {
    return Container(
        alignment: Alignment(-1.0, -1.0),
        //color: Colors.blue,
        child: TextButton(
            onPressed: () {
              launchUrl(Uri.parse(link));
            },
            child: Text(link,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.underline))),
        margin: EdgeInsets.only(left: 39));
  }

  Widget buildTitleString(String content) {
    return Container(
        alignment: Alignment(-1.0, -1.0),
        //color: Colors.red,
        child:
            Text(content, style: TextStyle(fontSize: 24, color: Colors.grey)),
        margin: EdgeInsets.only(left: 36, top: 15));
  }

  Widget buildValueString(String content) {
    return Container(
        alignment: Alignment(-1.0, -1.0),
        //color: Colors.blue,
        child: Text(content, style: TextStyle(fontSize: 32)),
        margin: EdgeInsets.only(left: 39));
  }
}
