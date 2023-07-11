import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildChatBox(author, text, time) {
  final date = DateTime.fromMillisecondsSinceEpoch(time);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 30,
          bottom: 7,
        ),
        child: Text(
          author,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 20,
          right: 140,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Text(
          DateFormat('jm').format(date),
          style: const TextStyle(fontSize: 10, color: Colors.black26),
        ),
      ),
      const SizedBox(height: 20)
    ],
  );
}

Widget buildMyChatBox(text) {
  return Align(
    alignment: Alignment.centerRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            right: 30,
            bottom: 7,
          ),
          child: Text(
            "나",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
            left: 140,
            right: 20,
          ),
          decoration: const BoxDecoration(
              color: Color(0xFFFF6332),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
