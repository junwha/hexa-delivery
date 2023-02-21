import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexa_delivery/main.dart';

class BoardPage extends StatefulWidget {
  final String food;
  const BoardPage(this.food, { super.key });

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State <BoardPage> {
  String storeName = 'test';
  int number = 10;
  String startTime = 'test';
  int cost = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.food),
        backgroundColor: Color.fromARGB(255, 10, 177, 199),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
            children: [
              SizedBox(
                height: 15,
                width: 350,
              ),
              SizedBox(
                height: 50,
                width: 350,
                child: Text('현재 모임',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0)
                  ),
              ),
              buildContainer(context),
              SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
            ],
          ),
      ),
    );
  }


  GestureDetector buildContainer(BuildContext context) {
    return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TestPage()));
              },
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      top: 7,
                      left: 15,
                      child: Text(storeName,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: Text('현재 ${number}명')
                    ),
                    Positioned(
                      bottom: 10,
                      left: 15,
                      child: Text('주문시간 '+startTime+'시'),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 50,
                      child: Text('배달료 ${cost}원'),
                    ),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                width: 350,
                height: 75,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 83, 216, 236),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2)
                ),
              ),
            );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}