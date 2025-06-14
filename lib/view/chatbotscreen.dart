import 'package:flutter/material.dart';
import 'package:health/models/chatmessage.dart';
import 'package:health/provider/languageprovider.dart';
import 'package:health/service/chat_service.dart';
import 'package:health/service/chatstorage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ChatStorageService _chatStorageService = ChatStorageService();
  final ChatService _chatService = ChatService();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _addBotMessage(
      "Hello! I'm your medical assistant. How can I help you today?",
    );
  }

  void _clearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              Provider.of<LanguageProvider>(context).getText('clear_chat'),
            ),

            content:  Text(
              Provider.of<LanguageProvider>(context).getText('are_you_sure_you_want_to_clear_the_chat_history?'),

            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:  Text(
                  Provider.of<LanguageProvider>(context).getText('cancel'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:  Text(
                  Provider.of<LanguageProvider>(context).getText('clear'),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _chatStorageService.clearMessages();
      setState(() {
        _messages.clear();
      });
    }
  }

  void _loadMessages() async {
    final loadedMessages = await _chatStorageService.loadMessages();
    setState(() => _messages.addAll(loadedMessages));
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: false, time: DateTime.now()),
      );
    });
    _chatStorageService.saveMessages(_messages);
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    final message = ChatMessage(text: text, isUser: true, time: DateTime.now());
    setState(() {
      _messages.add(message);
    });
    _chatStorageService.saveMessages(_messages);
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _addUserMessage(text);
    setState(() => _isLoading = true);

    try {
      final botResponse = await _chatService.sendMessage(text);
      _addBotMessage(botResponse);
    } catch (e) {
      _addBotMessage("Oops! ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Scroll to the top of the reversed list (bottom of chat)
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  hintText: 'Type something...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(30),
                    
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final bubbleColor =
        isUser
            ? Theme.of(context).primaryColor
            : Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200];

    final textColor = isUser ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('HH:mm').format(message.time),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title:  Text(
          Provider.of<LanguageProvider>(context).getText('medical_assistant'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            tooltip: Provider.of<LanguageProvider>(
                    context,
                  ).getText('clear_chat'),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              reverse: true, // Reverse the list to start from bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Adjust index for reversed list
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: const Text(
                      'AI is typing...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
