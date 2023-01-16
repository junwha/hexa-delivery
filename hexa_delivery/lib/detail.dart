import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

String input_title = 'test';

class Detail_page extends StatelessWidget {
  const Detail_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: input_title,
      debugShowCheckedModeBanner: false,
      home: Grade(),
    );
  }
}

String store_name = 'test';
String order_time = 'test';
String pickup_place = 'test';
String link = 'test';
int NUM = 0;
String num_p = '${NUM}명';

class Grade extends StatelessWidget {
  const Grade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          input_title,
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
            Container(
              alignment: Alignment(-1.0, -1.0),
              //color: Colors.red,
              child: Text(
                '가게 이름',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
              margin: EdgeInsets.only(left: 36, top: 29),
            ),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.blue,
                child: Text(store_name, style: TextStyle(fontSize: 32)),
                margin: EdgeInsets.only(left: 39)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.red,
                child: Text('주문 시간',
                    style: TextStyle(fontSize: 24, color: Colors.grey)),
                margin: EdgeInsets.only(
                  left: 36,
                )),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.blue,
                child: Text(order_time, style: TextStyle(fontSize: 32)),
                margin: EdgeInsets.only(left: 39)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.red,
                child: Text('픽업 장소',
                    style: TextStyle(fontSize: 24, color: Colors.grey)),
                margin: EdgeInsets.only(left: 36)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.blue,
                child: Text(pickup_place, style: TextStyle(fontSize: 32)),
                margin: EdgeInsets.only(left: 39)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.red,
                child: Text('현재 인원',
                    style: TextStyle(fontSize: 24, color: Colors.grey)),
                margin: EdgeInsets.only(left: 36)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.blue,
                child: Text(num_p, style: TextStyle(fontSize: 32)),
                margin: EdgeInsets.only(left: 39)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.red,
                child: Text('메뉴 보러가기',
                    style: TextStyle(fontSize: 24, color: Colors.grey)),
                margin: EdgeInsets.only(left: 36)),
            Container(
                alignment: Alignment(-1.0, -1.0),
                //color: Colors.blue,
                child: TextButton(
                    onPressed: () {},
                    child: Text(link,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            decoration: TextDecoration.underline))),
                margin: EdgeInsets.only(left: 39)),
            Center(
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
                  margin: EdgeInsets.only(top: 40)),
            ),
          ],
        ),
      ),
    );
  }
}
