import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nichol_ui_lib_input_handler/nichol_ui_lib_input_handler.dart';
import './custom_navbar.dart';
import 'package:nichol_ui_lib_modals_and_button_triggers/nichol_ui_lib_modals_and_button_triggers.dart';
import 'package:nichol_ui_lib_list_handler/nichol_ui_lib_list_handler.dart';
import 'theme.dart';
import 'chat_room_chat_feed_only.dart';
import 'logic/ai_state.dart';
import 'logic/ai_company.dart';
import 'logic/chat_state.dart';


class ChatRoom extends ConsumerWidget {
  final bool userWantsResponse = true;
  final Map<String, String> apiKeys;

  ChatRoom({
    Key? key,
    required this.apiKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSendHandler(String data) async {
      await ref.read(chatProvider.notifier).addMessageToCurrentConversation(
            data,
            true,
          );

      if (userWantsResponse == true) {
        final aiState = ref.read(aiProvider);

final currentService = aiState.currentService;

String response = await currentService.sendHandler(
  ref
      .read(chatProvider)
      .allConversations[
          ref.read(chatProvider).currentConversationIndex]
      .messages,
);

await ref
    .read(chatProvider.notifier)
    .addMessageToCurrentConversation(response, false);
      }
    }
 
      void createConversation(String title) async {
        await ref.read(chatProvider.notifier).addConversation(title);
      }
      final conversations = ref.watch(chatProvider).allConversations;
      void handleTheDeletion(int key) {
        ref.read(chatProvider.notifier).deleteConversation(key);
        // LEAVE THIS IT WILL NOT UPDATE OTHERWISE!!!!
        Navigator.of(context).pop();
      }
      
      void handleTheTap(int key) {
        ref.read(chatProvider.notifier).switchConversation(key);
        // LEAVE THIS IT WILL NOT UPDATE OTHERWISE!!!!
        Navigator.of(context).pop();
      }
     
      void handleTheEdit(String string) {
        ref.read(chatProvider.notifier).changeConversationTitle(string);
        // LEAVE THIS IT WILL NOT UPDATE OTHERWISE!!!!
        Navigator.of(context).pop();
      }
                        

      List<NicholUILibListItem> activeConversations = conversations.asMap().entries.map((conversation) => NicholUILibListItem(
          key: ValueKey(conversation.key),
          title: conversation.value.title,
          iteration: conversation.key,
          isSelected: conversation.key == ref.read(chatProvider).currentConversationIndex,
          onTap: () => handleTheTap(conversation.key),
          editOption: (string) => handleTheEdit(string),
          deleteOption: () => handleTheDeletion(conversation.key),
      )).toList();
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;

      return Scaffold(
         appBar: CustomNavBar(
              navBarTitleWidget: Text("Language Learning Partner"),
              backgroundColor: ChatRoomTheme.navBarColor,
              navBarWidgets:[
                NicholUILibModalToggleButtonWithTemplateModalPage(
                  modalTitle:"Enter name of new conversation",
                  buttonText: "Create Conversation",
                  modalOnSubmit: createConversation,
                ),
              NicholUILibModalToggleButtonWithCustomModalPage(
                 key: ValueKey(conversations.length),
                 modalPage: Container(
                    color: Colors.blue,
                  
                 child: NicholUILibListHandler(
                     key: ValueKey(ref.watch(chatProvider).allConversations.length),
                      selectedListItem: ref.watch(chatProvider).currentConversationIndex,
                      listItems: activeConversations,
                  )),
                 buttonText: "Saved Conversations",
                  
                ),
                DropdownButton<AiCompany>(
  value: ref.watch(aiProvider).selectedService,
  items: AiCompany.values.map((company) {
    return DropdownMenuItem(
      value: company,
      child: Text(company.displayName),
    );
  }).toList(),
  onChanged: (value) {
    if (value != null) {
      ref.read(aiProvider.notifier).selectService(value);
    }
  },
)
             ],

                  initialSubNavTitle: ref.watch(chatProvider).allConversations.length > 0 ? ref.watch(chatProvider).allConversations[ref.read(chatProvider).currentConversationIndex].title : "No Chats",
                  subNavTitleOnSave: ref.read(chatProvider.notifier).changeConversationTitle,
            ),


        body: Container(
          color: ChatRoomTheme.backgroundColor,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: ChatRoomChatFeed(),
              ),
              SizedBox(
                height: height * 0.1,
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NicholUILibInputHandler(
                      onSend: onSendHandler,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
