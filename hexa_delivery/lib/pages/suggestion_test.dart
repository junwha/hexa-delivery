import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../model/backend.dart' as backend;

class SuggestionTestPage extends StatelessWidget {
  SuggestionTestPage({super.key});
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 페이지'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.search,
                          size: 40,
                        ),
                      ),
                      hintText: '가게 이름을 입력해주세요',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Color(0xff81ccd1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  suggestionsCallback: backend.getStoreNamesTest,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    print(suggestion);
                    controller.text = suggestion;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
