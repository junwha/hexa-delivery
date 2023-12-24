import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexa_delivery/bloc/create_group_page_bloc.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/model/thousands_separator.dart';

class CreateGroupPage extends StatefulWidget {
  final StoreDTO store;
  final String? url;
  const CreateGroupPage({
    super.key,
    required this.store,
    this.url,
  });

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  late final CreateGroupPageBloc bloc;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController storeNameTextFieldController;
  late final String? Function(String?) storeNameTextFieldValidator;
  late final TextEditingController linkTextFieldController;
  late final String? Function(String?) linkTextFieldValidator;
  late final TextEditingController orderTimeTextFieldController;
  late final String? Function(String?) orderTimeTextFieldValidator;
  late final TextEditingController orderFeeTextFieldController;
  late final String? Function(String?) orderFeeTextFieldValidator;
  late final TextEditingController orderPlaceTextFieldController;
  late final String? Function(String?) orderPlaceTextFieldValidator;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      bloc.onTimerTick();
    });
    _ticker.start();

    bloc = CreateGroupPageBloc(
      store: widget.store,
      link: widget.url,
      context: context,
    );
    formKey = bloc.formKey;
    storeNameTextFieldController = bloc.storeNameTextFieldController;
    storeNameTextFieldValidator = bloc.storeNameTextFieldValidator;
    linkTextFieldController = bloc.linkTextFieldController;
    linkTextFieldValidator = bloc.linkTextFieldValidator;
    orderTimeTextFieldController = bloc.orderTimeTextFieldController;
    orderTimeTextFieldValidator = bloc.orderTimeTextFieldValidator;
    orderFeeTextFieldController = bloc.orderFeeTextFieldController;
    orderFeeTextFieldValidator = bloc.orderFeeTextFieldValidator;
    orderPlaceTextFieldController = bloc.orderPlaceTextFieldController;
    orderPlaceTextFieldValidator = bloc.orderPlaceTextFieldValidator;
  }

  @override
  void dispose() {
    _ticker.dispose();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('모임 열기'),
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
              bottom: 80,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSubTitle("🏠", "가게 이름"),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  "${widget.store.name} 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집 치킨집",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          buildSubTitle("🚚", "배달의 민족 \"함께주문\" 링크"),
                          buildLinkTextField(),
                          const SizedBox(
                            height: 20,
                          ),
                          buildSubTitle("🕰️", "주문할 시간"),
                          buildOrderTimeTextField(),
                          orderTimeRemainingText(),
                          const SizedBox(
                            height: 20,
                          ),
                          buildSubTitle("💵", "배달료"),
                          buildOrderFeeTextField(),
                          const SizedBox(
                            height: 20,
                          ),
                          buildSubTitle("🛕", "모이는 장소"),
                          buildOrderPlaceTextField(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: buildCreateGroupButton(),
      ),
    );
  }

  Widget buildSubTitle(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(
              fontFamily: 'Tossface',
              fontSize: 20,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black45,
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget buildStoreNameTextField() {
    return StreamBuilder(
      stream: bloc.storeNameTextFieldStream,
      builder: (context, snapshot) {
        return TextFormField(
          controller: storeNameTextFieldController,
          enabled: snapshot.data?.isEnabled ?? false,
          validator: storeNameTextFieldValidator,
          autovalidateMode: AutovalidateMode.always,
          onSaved: bloc.onStoreNameSaved,
        );
      },
    );
  }

  Widget buildLinkTextField() {
    return StreamBuilder(
      stream: bloc.linkTextFieldStream,
      builder: (context, snapshot) {
        return TextFormField(
            controller: linkTextFieldController,
            enabled: snapshot.data?.isEnabled ?? false,
            validator: linkTextFieldValidator,
            autovalidateMode: AutovalidateMode.always,
            onSaved: bloc.onLinkSaved,
            decoration: const InputDecoration(
              hintText: 'https://s.baemin.com/.........',
            ));
      },
    );
  }

  Widget buildOrderTimeTextField() {
    return StreamBuilder(
      stream: bloc.orderTimeTextFieldStream,
      builder: (context, snapshot) {
        return TextFormField(
          readOnly: true,
          controller: orderTimeTextFieldController,
          enabled: snapshot.data?.isEnabled ?? false,
          validator: orderTimeTextFieldValidator,
          autovalidateMode: AutovalidateMode.always,
          onSaved: bloc.onOrderTimeSaved,
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
                initialTime: bloc.initialTime,
                context: context,
                helpText: '24시간 후까지 선택 가능합니다.');
            bloc.onOrderTimeSelected(pickedTime);
          },
        );
      },
    );
  }

  Widget orderTimeRemainingText() {
    return StreamBuilder(
      stream: bloc.orderTimeRemainingTextStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          return Align(
            alignment: Alignment.centerRight,
            child: Text(
              snapshot.data!.text,
              style: TextStyle(
                color: snapshot.data!.isEmphasized ? Colors.red : Colors.black,
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildOrderFeeTextField() {
    return StreamBuilder(
      stream: bloc.orderFeeTextFieldStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: const InputDecoration(
            prefixText: "₩",
          ),
          controller: orderFeeTextFieldController,
          enabled: snapshot.data?.isEnabled ?? false,
          validator: orderFeeTextFieldValidator,
          autovalidateMode: AutovalidateMode.always,
          onSaved: bloc.onOrderFeeSaved,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter(),
          ],
        );
      },
    );
  }

  Widget buildOrderPlaceTextField() {
    return StreamBuilder(
      stream: bloc.orderPlaceTextFieldStream,
      builder: (context, snapshot) {
        return TextFormField(
          controller: orderPlaceTextFieldController,
          enabled: snapshot.data?.isEnabled ?? false,
          validator: orderPlaceTextFieldValidator,
          autovalidateMode: AutovalidateMode.always,
          onSaved: bloc.onOrderPlaceSaved,
        );
      },
    );
  }

  Widget buildCreateGroupButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: StreamBuilder(
        stream: bloc.createGroupButtonStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data?.isEnabled ?? false
                ? () {
                    bloc.onCreateGroupButtonPressed();
                  }
                : null,
            child: const Text('모임 열기'),
          );
        },
      ),
    );
  }
}
