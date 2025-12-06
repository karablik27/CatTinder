import 'dart:convert';
import 'package:http/http.dart' as http;

class CatNameService {
  static const apiKey =
      "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";

  Future<String> generateCatName(String imageUrl) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    try {
      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "cat-tinder.app",
          "X-Title": "CatTinder",
        },
        body: jsonEncode({
          "model": "amazon/nova-lite-v1",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "Придумай милое, короткое имя этому коту по фото. Только имя:",
                },
                {
                  "type": "image_url",
                  "image_url": {"url": imageUrl},
                },
              ],
            },
          ],
        }),
      );

      if (res.statusCode != 200) throw Exception("OpenRouter error");

      final data = jsonDecode(res.body);
      return (data["choices"][0]["message"]["content"] as String).trim();
    } catch (_) {
      return "Без имени";
    }
  }
}
