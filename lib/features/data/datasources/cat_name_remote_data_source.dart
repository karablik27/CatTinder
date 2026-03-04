import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app/app_secrets.dart';

class CatNameRemoteDataSource {
  Future<String> generateCatName(String imageUrl) async {
    if (!AppSecrets.hasOpenRouterApiKey) {
      return 'Без имени';
    }

    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    try {
      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppSecrets.openRouterApiKey}',
          'Content-Type': 'application/json',
          'HTTP-Referer': AppSecrets.openRouterReferer,
          'X-Title': AppSecrets.openRouterTitle,
        },
        body: jsonEncode({
          'model': 'amazon/nova-lite-v1',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      'Придумай милое, короткое имя этому коту по фото. Только имя:',
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': imageUrl},
                },
              ],
            },
          ],
        }),
      );

      if (res.statusCode != 200) {
        throw Exception('OpenRouter error');
      }

      final data = jsonDecode(res.body);
      return (data['choices'][0]['message']['content'] as String).trim();
    } catch (_) {
      return 'Без имени';
    }
  }
}
