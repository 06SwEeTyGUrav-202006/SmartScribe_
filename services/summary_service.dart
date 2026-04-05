import 'dart:convert';
import 'package:http/http.dart' as http;

class SummarizeService {
  static const String apiKey = "";

  static Future<String> summarizeText(String text) async {
    text = text.trim();

    print("🔵 TRANSCRIPTION RECEIVED:");
    print(text);

    if (text.isEmpty || text.length < 20) {
      return "⚠️ Audio too short to summarize.";
    }

    final response = await http.post(
      Uri.parse(""),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "temperature": 0,
        "messages": [
          {
            "role": "system",
            "content":
            "Translate any language to English and summarize in clear bullet points."
          },
          {
            "role": "user",
            "content": text
          }
        ]
      }),
    );

    print("🟢 OPENAI STATUS: ${response.statusCode}");
    print("🟢 OPENAI RESPONSE:");
    print(response.body);

    if (response.statusCode != 200) {
      return "❌ OpenAI error ${response.statusCode}";
    }

    final data = jsonDecode(response.body);

    if (data["choices"] == null ||
        data["choices"].isEmpty ||
        data["choices"][0]["message"]["content"] == null) {
      return "❌ Summary not generated";
    }

    return data["choices"][0]["message"]["content"].trim();
  }
}
