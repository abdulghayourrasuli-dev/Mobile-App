import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/chat_message.dart';

class GeminiService {
  static const String _systemPrompt = '''
You are a friendly English teacher for absolute beginner Dari (Afghan Persian) speakers.

Rules:
1. Always reply in BOTH English and Dari. Show the English first, then a short Dari explanation/translation below it.
2. If the user writes an incorrect English sentence, show the corrected sentence first, then explain the mistake simply in Dari.
3. If the user asks to translate Dari to English or English to Dari, give an accurate translation showing both languages.
4. Keep replies short, simple, and beginner-friendly. Add one short example sentence when useful.
5. Avoid complex grammar terms unless you explain them in simple Dari.
6. Always be encouraging and positive.
''';

  Future<String> sendMessage(List<ChatMessage> history) async {
    final contents = [
      {
        'role': 'user',
        'parts': [
          {'text': _systemPrompt}
        ],
      },
      {
        'role': 'model',
        'parts': [
          {
            'text':
                'بسیار خوب، من آماده‌ام تا به شما انگلیسی یاد بدهم. (Okay, I am ready to teach you English.)'
          }
        ],
      },
      ...history.map((m) => {
            'role': m.isUser ? 'user' : 'model',
            'parts': [
              {'text': m.text}
            ],
          }),
    ];

    final response = await http.post(
      Uri.parse(ApiConfig.endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': contents,
        'generationConfig': {
          'temperature': 0.6,
          'maxOutputTokens': 512,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response from AI');
    }

    final parts = candidates[0]['content']['parts'] as List;
    return parts.map((p) => p['text'] as String).join();
  }
}
