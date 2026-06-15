import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GeminiService _service = GeminiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: 'Hello! 👋 I am your English teacher.\n'
          'سلام! من معلم انگلیسی شما هستم.\n\n'
          'You can:\n'
          '- Chat with me to practice English\n'
          '- Send a sentence to fix mistakes\n'
          '- Ask me to translate Dari ↔ English\n\n'
          'شما می‌توانید با من گفتگو کنید، جمله بفرستید تا تصحیح شود، یا ترجمه بخواهید.',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final reply = await _service.sendMessage(_messages);
      setState(() {
        _messages.add(ChatMessage(text: reply, isUser: false));
      });
    } catch (_) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Error: could not get a response. Please check your internet or API key.\n'
              'خطا: عدم دریافت پاسخ. لطفاً اتصال انترنت یا کلید API را بررسی کنید.',
          isUser: false,
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English with Dari'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  MessageBubble(message: _messages[index]),
            ),
          ),
          ChatInput(
            controller: _controller,
            onSend: _send,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
