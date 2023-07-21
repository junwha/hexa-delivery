import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexa_delivery/bloc/board_bloc.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/settings.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import 'package:hexa_delivery/widgets/order_desc_card.dart';


class BoardPage extends StatefulWidget {
  const BoardPage(this.category, {super.key});
  final Category category;

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final ScrollController _scrollController = ScrollController();
  BoardBloc boardPageBloc = BoardBloc();
  Timer? _debounce;

  @override 
  void initState() {
    boardPageBloc.fetchNextPage(category: widget.category);
    _scrollController.addListener((){
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= kScrollThreshold &&
          !(_debounce?.isActive ?? false)) {
        _debounce = Timer(kFetchThreshold, () {
          boardPageBloc.fetchNextPage(category: widget.category);
        });
      }
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kCategory2String[widget.category] ?? "Error"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, // 뒤로가기
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                '현재 모임',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            StreamBuilder(stream: boardPageBloc.getOrderStream,
              builder: (context, snapshot) {
                return snapshot.hasData ? 
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return OrderDescCard(snapshot.data![index]);
                        },
                        controller: _scrollController,
                        itemCount: snapshot.data!.length,
                      ),
                    ),
                  ) : 
                  const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }  
}