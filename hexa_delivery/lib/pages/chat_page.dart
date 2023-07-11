import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/widgets/chat_box.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.order, required this.userName});

  final OrderDTO order;
  final String userName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      }, // 뒤로가기
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  late DatabaseReference ref;
  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance
        .ref('chat')
        .child(widget.order.oid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        appBar: AppBar(
          title: const Text("채팅방"),
          leading: const PreviousButton(),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              buildOrderInfo(widget.order),
              Expanded(
                flex: 8,
                child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFFFF6332)),
                          SizedBox(height: 20),
                          Text("채팅창을 불러오는 중입니다."),
                        ],
                      );
                    }

                    if (snapshot.data?.snapshot.value == null) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("대화 내용이 없습니다."),
                      );
                    }

                    Map chatData = snapshot.data?.snapshot.value as Map;
                    List lists = chatData.values.toList();

                    lists.sort((a, b) => b['time'].compareTo(a['time']));

                    lists
                        .insert(0, {'name': 'space', 'text': '120', 'time': 0});
                    lists.add({'name': 'space', 'text': '30', 'time': 0});

                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: lists.length,
                      itemBuilder: (context, index) {
                        if (lists[index]['name'] == 'space') {
                          return SizedBox(
                              height: double.parse(lists[index]['text']));
                        }
                        if (lists[index]['name'] == widget.userName) {
                          return buildMyChatBox(lists[index]['text']);
                        }
                        return buildChatBox(lists[index]['name'],
                            lists[index]['text'], lists[index]['time']);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartDocked,
        bottomSheet: buildTextForm(),
      ),
    );
  }

  Widget buildTextForm() {
    TextEditingController tec = TextEditingController();
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 40,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: tec,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "텍스트를 입력하세요.",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (tec.text.isEmpty) {
                      return;
                    }
                    DatabaseReference ref = FirebaseDatabase.instance
                        .ref('chat/${widget.order.oid}');
                    final Map<String, dynamic> chatData = {
                      'name': widget.userName,
                      "text": tec.text,
                      "time": DateTime.now().millisecondsSinceEpoch,
                    };

                    final newPostKey = ref.push().key;
                    final Map<String, Map> updates = {};
                    updates['/$newPostKey'] = chatData;
                    ref.update(updates);
                    tec.text = "";
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    elevation: 0,
                    backgroundColor: const Color(0xFFFF6332),
                  ),
                  child: const Text(
                    '보내기',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildOrderInfo(OrderDTO order) {
  return Padding(
    padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
    child: Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 238, 232),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: double.infinity,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.name,
                  style: const TextStyle(
                      color: Color(0xFFFF6332),
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "${order.numOfMembers}명 신청",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${order.expTime.hour}시 ${order.expTime.minute}분 주문 예정",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "배달비 ${order.fee}원",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
