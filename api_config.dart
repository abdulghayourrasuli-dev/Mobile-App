import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String model = 'gemini-2.0-flash';

  static String get endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$geminiApiKey';
}
