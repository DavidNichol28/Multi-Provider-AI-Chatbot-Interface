import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversation.dart';

class LocalMemoryService {
  static const String _conversationsKey = 'conversations';

  // Fetch all conversations from SharedPreferences
  Future<List<Conversation>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = prefs.getString(_conversationsKey);
    if (conversationsJson != null) {
      final List<dynamic> conversationsList = jsonDecode(conversationsJson);
      return conversationsList.map((e) => Conversation.fromJson(e)).toList();
    }
    return [];
  }

  // Add a single message to an existing conversation
  Future<void> addMessageToConversation(
    String conversationId, Message newMessage) async {
    final conversations = await getConversations();

    // Find the conversation by its ID
    final conversationIndex =
        conversations.indexWhere((conv) => conv.id == conversationId);
        if (conversationIndex != -1) {
      // Add the new message to the conversation's messages
      conversations[conversationIndex].messages.add(newMessage);

      // Save the updated conversations list
      await saveConversations(conversations);
    }
  }

  // Save all conversations to SharedPreferences
  Future<void> saveConversations(List<Conversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = jsonEncode(conversations.map((e) => e.toJson()).toList());
    await prefs.setString(_conversationsKey, conversationsJson);

  }

  // Add a new conversation
  Future<void> addConversation(Conversation conversation) async {
    final conversations = await getConversations();
    conversations.add(conversation);
    await saveConversations(conversations);
  }

  // Update an existing conversation
  Future<void> updateConversation(Conversation updatedConversation) async {
    final conversations = await getConversations();
    final index = conversations.indexWhere((conv) => conv.id == updatedConversation.id);
    if (index != -1) {
      conversations[index] = updatedConversation;
      await saveConversations(conversations);
    }
  }

  // Delete a conversation by ID
  Future<void> deleteConversation(int index) async {
    final conversations = await getConversations();
    conversations.removeAt(index);
    await saveConversations(conversations);
  }
}
