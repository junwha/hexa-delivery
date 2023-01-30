import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

String food = '음식 종류';
String store1 = '가게1';
String people1 = '1';
String time1 = 'a1';
String cost1 = '1';
String store2 = '가게명2';
String people2 = '2';
String time2 = 'a2';
String cost2 = '2';
String store3 = '가게명3';
String people3 = '3';
String time3 = 'a3';
String cost3 = '3';
String store4 = '가게명4';
String people4 = '4';
String time4 = 'a4';
String cost4 = '4';
String store5 = '가게명5';
String people5 = '5';
String time5 = 'a5';
String cost5 = '5';


class _BoardPageState extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food),
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
              GestureDetector(
                onTap: () {
                  print('First button clicked');
                },
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 7,
                        left: 15,
                        child: Text(store1,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: Text('현재 '+people1+'명')
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Text('주문시간 '+time1+'시'),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: Text('배달료 '+cost1+'원'),
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
              ),
              SizedBox(
                height: 15,
                width: 350,
              ),
              GestureDetector(
                onTap: () {
                  print('Second button clicked');
                },
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 7,
                        left: 15,
                        child: Text('가게명',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: Text('현재 a명')
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Text('주문시간 a시'),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: Text('배달료 a원'),
                      ),
                    ],
                  ),
                  width: 350,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 83, 216, 236),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2)
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                width: 350,
              ),
              GestureDetector(
                onTap: () {
                  print('Third button clicked');
                },
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 7,
                        left: 15,
                        child: Text('가게명',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: Text('현재 a명')
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Text('주문시간 a시'),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: Text('배달료 a원'),
                      ),
                    ],
                  ),
                  width: 350,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 83, 216, 236),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2)
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                width: 350,
              ),
              GestureDetector(
                onTap: () {
                  print('Fourth button clicked');
                },
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 7,
                        left: 15,
                        child: Text('가게명',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: Text('현재 a명')
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Text('주문시간 a시'),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: Text('배달료 a원'),
                      ),
                    ],
                  ),
                  width: 350,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 83, 216, 236),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2)
                  ),
                ),
              ),
              SizedBox(
                height: 15,
                width: 350,
              ),
              GestureDetector(
                onTap: () {
                  print('Fifth button clicked');
                },
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 7,
                        left: 15,
                        child: Text('가게명',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: Text('현재 a명')
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        child: Text('주문시간 a시'),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 50,
                        child: Text('배달료 a원'),
                      ),
                    ],
                  ),
                  width: 350,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 83, 216, 236),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2)
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

