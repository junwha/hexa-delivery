import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  String inputTitle;
  String storeName;
  String orderTime;
  String pickupPlace;
  String link;
  int num;

  //DetailPage({super.key});
  DetailPage(
      {required this.inputTitle,
      required this.storeName,
      required this.orderTime,
      required this.pickupPlace,
      required this.link,
      required this.num});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          inputTitle,
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
            buildValueString(storeName),
            buildTitleString('주문 시간'),
            buildValueString(orderTime),
            buildTitleString('픽업 장소'),
            buildValueString(pickupPlace),
            buildTitleString('현재 인원'),
            buildValueString('${num}명'),
            buildTitleString('메뉴 보러가기'),
            buildLinkedButton(link),
            participationButton(),
          ],
        ),
      ),
    );
  }

  Center participationButton() {
    return Center(
      child: Container(
          //color: Colors.red,
          width: 315,
          height: 94,
          child: ElevatedButton(
            onPressed: () {},
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

  Widget buildLinkedButton(String link1) {
    return Container(
        alignment: Alignment(-1.0, -1.0),
        //color: Colors.blue,
        child: TextButton(
            onPressed: () {
              launchUrl(Uri.parse(link1));
            },
            child: Text(link1,
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
