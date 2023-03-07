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
  String storeName = 'BHC 구영점';
  int number = 10;
  String startTime = '10';
  int cost = 10;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food),
        backgroundColor: const Color.fromARGB(255, 129, 204, 209),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
            children: [
              const SizedBox(
                height: 28,
                width: 350,
              ),
              const SizedBox(
                height: 51,
                width: 350,
                child: Text('현재 모임',
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 118, 119),
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0)
                  ),
              ),
              buildContainer(context),
              const SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              const SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              const SizedBox(
                height: 15,
                width: 350,
              ),
              buildContainer(context),
              const SizedBox(
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
                  builder: (context) => const TestPage()));
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 12),
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                width: 344,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 237, 239),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(storeName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500
                          ),
                        ),
                        Text('현재 $number명',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('주문시간 ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 99, 118, 119),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                              ),
                            ), 
                            Text('$startTime시',
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                        Text('배달료 $cost원',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ],
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