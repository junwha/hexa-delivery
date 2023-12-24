import 'package:flutter/material.dart';

class SearchStoresPage extends StatefulWidget {
  const SearchStoresPage({super.key});

  @override
  State<SearchStoresPage> createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 검색'),
      ),
      body: const Center(
        child: Text('가게 검색 페이지'),
      ),
    );
  }
}
