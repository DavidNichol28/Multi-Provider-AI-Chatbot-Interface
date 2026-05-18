import 'dart:convert';
import 'package:http/http.dart' as http;
import 'conversation.dart';
import 'ai_company.dart';

class AiService {
  final AiCompany aiCompany;
  String model;
  num maxTokens;
  double temperature;
  double topP;
  double topK;
  int frequencyPenalty;
  int presencePenalty;
  String keyForService;

  AiService({
    required this.aiCompany,
    required this.model,
    required this.maxTokens,
    this.temperature = 0.7,
    this.topP = 1.0,
    this.topK = 1.0,
    this.frequencyPenalty = 0,
    this.presencePenalty = 0,
    required this.keyForService,
  });

  Future<String> sendHandler(List<Message> chatHistory) async {
    print("keyForService: $keyForService");
    if (keyForService == null || keyForService == '') {
      throw ArgumentError('API key is missing for the selected AI service.');
    }

    final url = aiCompany == AiCompany.google
        ? '${aiCompany.url}/$model:generateContent?key=$keyForService'
        : aiCompany.url;
    // Build request dynamically based on service
    final requestBody = _buildRequestBody(chatHistory);
    print("REQUESTBODY: $requestBody");
    final response = await http.post(
      Uri.parse(url),
      headers: aiCompany.headers(keyForService),
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      print("responseData $responseData");
      if (aiCompany == AiCompany.google) {
        return responseData['candidates']
                ?.first['content']['parts']
                ?.first['text'] ??
            'No response text.';
      } else if (aiCompany == AiCompany.anthropic) {
        return responseData['content']?.first['text'] ?? 'No response text.';
      } else {
        return 'Unexpected AI service.';
      }
    } else {
      throw Exception(
          'Failed with status code: ${response.statusCode}. Error: ${response.body}');
    }
  }

  AiService copyWithValue({required String key, required dynamic value}) {
    switch (key) {
      case 'model':
        return copyWith(model: value);
      case 'maxTokens':
        return copyWith(maxTokens: value);
      case 'temperature':
        return copyWith(temperature: value);
      case 'topP':
        return copyWith(topP: value);
      case 'topK':
        return copyWith(topK: value);
      case 'frequencyPenalty':
        return copyWith(frequencyPenalty: value);
      case 'presencePenalty':
        return copyWith(presencePenalty: value);
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  AiService copyWith({
    AiCompany? aiCompany,
    String? model,
    num? maxTokens,
    double? temperature,
    double? topP,
    double? topK,
    int? frequencyPenalty,
    int? presencePenalty,
    String? keyForService,
  }) {
    return AiService(
      aiCompany: aiCompany ?? this.aiCompany,
      model: model ?? this.model,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      keyForService: keyForService ?? this.keyForService,
    );
  }

  Map<String, dynamic> _buildRequestBody(List<Message> chatHistory) {
    switch (aiCompany) {
      case AiCompany.google:
        return {
          "contents": [
            {
              "parts": chatHistory.map((m) => {"text": m.message}).toList(),
            }
          ],
          "generation_config": {
            "temperature": temperature,
            "top_p": topP,
            "top_k": topK,
            "max_output_tokens": maxTokens,
          }
        };

      case AiCompany.anthropic:
        return {
          "model": model,
          "max_tokens": maxTokens,
          // Can't have both temperature and top_p in this API
          // (and shouldn't anywhere regardless) 
          "temperature": temperature,
          // "top_p": topP,
          
          "messages": chatHistory
              .map((m) => {
                    "role": m.isUserMessage ? "user" : "assistant",
                    "content": m.message
                  })
              .toList(),
        };


      default:
        throw UnimplementedError('AI Service not implemented');
    }
  }
}
