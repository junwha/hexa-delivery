import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/create_group_page.dart';
import 'package:hexa_delivery/resources/store_resource.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class SearchStoresPage extends StatefulWidget {
  const SearchStoresPage({super.key});

  @override
  State<SearchStoresPage> createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  StoreDTO? store;
  final TextEditingController storeNameSelectTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('가게 찾기'),
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
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                storeNameTextField(),
                if (store != null)
                  const SizedBox(
                    height: 50,
                  ),
                if (store != null) const Divider(),
                if (store != null)
                  const SizedBox(
                    height: 10,
                  ),
                if (store != null)
                  Text(
                    '${store!.name}의 주문',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                //TODO: 이 가게의 이미 생성된 주문들 보여주기
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: ElevatedButton(
            onPressed: storeNameSelectTextFieldController.text == ''
                ? null
                : () async {
                    if (store == null) {
                      StoreCreateDTO storeCreateDTO = StoreCreateDTO(
                        storeNameSelectTextFieldController.text,
                      );

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  color: kThemeData.primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      var rid = await StoreResource.createStoreAndGetRID(
                          storeCreateDTO);

                      if (rid < 0) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('가게 생성에 실패했습니다. 잠시 후 다시 시도해주세요.'),
                          ),
                        );
                      } else {
                        store = StoreDTO(
                          rid: rid,
                          name: storeCreateDTO.getName,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CreateGroupPage(
                            store: store!,
                          );
                        },
                      ),
                    );
                  },
            child: const Text('이 가게로 주문 생성하기'),
          ),
        ),
      ),
    );
  }

  TypeAheadFormField<T> buildOCTypeAheadFormField<T>({
    required String hintText,
    required Widget Function(BuildContext, dynamic) itemBuilder,
    required TextEditingController? controller,
    required FutureOr<Iterable<T>> Function(String) suggestionsCallback,
    required void Function(T) onSuggestionSelected,
    Widget Function(BuildContext)? noItemsFoundBuilder,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
  }) {
    return TypeAheadFormField<T>(
      noItemsFoundBuilder: noItemsFoundBuilder ??
          (context) {
            return const ListTile(
              title: Text('알 수 없는 오류가 발생했습니다.'),
            );
          },
      textFieldConfiguration: TextFieldConfiguration(
        onChanged: onChanged,
        controller: controller,
        autofocus: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
          ),
          hintText: hintText,
        ),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (val) {
        if (val == null || val.isEmpty) return hintText;
        return null;
      },
      onSaved: onSaved,
      suggestionsCallback: suggestionsCallback,
      debounceDuration: const Duration(
        milliseconds: 1000,
      ),
      animationDuration: Duration.zero,
      itemBuilder: itemBuilder,
      onSuggestionSelected: onSuggestionSelected,
    );
  }

  TypeAheadFormField<dynamic> storeNameTextField() {
    return buildOCTypeAheadFormField(
      itemBuilder: (context, suggestion) {
        String text = suggestion == null ? "" : suggestion.getName;
        if (suggestion != null && suggestion is StoreCreateDTO) {
          text = "새로운 가게 \"${suggestion.getName}\" 추가하기";
        }
        return ListTile(
          title: Text(text),
        );
      },
      controller: storeNameSelectTextFieldController,
      hintText: "가게 이름을 입력하세요.",
      suggestionsCallback: (query) {
        print("query: $query");

        return StoreResource.getStoreList(query);
      },
      onSuggestionSelected: (suggestion) {
        storeNameSelectTextFieldController.text = suggestion.getName;
        setState(() {
          store = suggestion;
        });
      },
      noItemsFoundBuilder: (context) {
        return const ListTile(
          title: Text('검색 결과가 없습니다.'),
        );
      },
      onChanged: (val) {
        setState(() {
          store = null;
        });
      },
    );
  }
}
