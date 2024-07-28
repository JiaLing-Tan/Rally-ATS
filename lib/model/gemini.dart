import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class Gemini{

  static late String? geminiResponse;
  static final model = GenerativeModel(model: "gemini-1.5-flash", apiKey: dotenv.env['geminiApiKey']!);

  static Future<void> callGemini(prompt) async {
    print("calling gemini");
    final response = await model.generateContent([
      Content.text("Write me a one-line concise description for documentation according to this given document content: $prompt. Just response the concise description without any explanation."),
      // Content.data("image/png", imageBytes),
    ]);
    geminiResponse = response.text;
  }

}