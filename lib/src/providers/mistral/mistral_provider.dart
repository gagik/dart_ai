/// Mistral AI provider implementation
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/types.dart';

/// Mistral AI API client
class MistralProvider {
  static const String defaultBaseUrl = 'https://api.mistral.ai/v1';

  final String apiKey;
  final String baseUrl;
  final Map<String, String> headers;
  final Duration timeout;
  final http.Client _client;

  MistralProvider({
    required this.apiKey,
    this.baseUrl = defaultBaseUrl,
    Map<String, String>? headers,
    this.timeout = const Duration(seconds: 60),
    http.Client? client,
  }) : headers = {
         'Authorization': 'Bearer $apiKey',
         'Content-Type': 'application/json',
         ...?headers,
       },
       _client = client ?? http.Client();

  /// Generate text completion using Mistral AI API
  Future<GenerateTextResult> generateText(
    String modelId,
    GenerateTextOptions options,
  ) async {
    final requestBody = {
      'model': modelId,
      'messages': [
        {'role': 'user', 'content': options.prompt},
      ],
      if (options.maxTokens != null) 'max_tokens': options.maxTokens,
      if (options.temperature != null) 'temperature': options.temperature,
      if (options.topP != null) 'top_p': options.topP,
      if (options.stop != null && options.stop!.isNotEmpty)
        'stop': options.stop,
      if (options.seed != null)
        'random_seed': options.seed, // Mistral uses 'random_seed'
      // Note: Mistral doesn't support frequency_penalty and presence_penalty
    };

    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/chat/completions'),
            headers: headers,
            body: json.encode(requestBody),
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        final errorBody = json.decode(response.body) as Map<String, dynamic>;
        final message =
            errorBody['message'] as String? ??
            errorBody['detail'] as String? ??
            'Mistral AI API request failed';

        throw AIException(
          message,
          code: errorBody['type']?.toString(),
          details: {
            'status_code': response.statusCode,
            'response_body': errorBody,
          },
        );
      }

      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      final choices = responseBody['choices'] as List<dynamic>;
      if (choices.isEmpty) {
        throw const AIException('No choices returned from Mistral AI API');
      }

      final choice = choices.first as Map<String, dynamic>;
      final message = choice['message'] as Map<String, dynamic>;
      final content = message['content'] as String? ?? '';

      final finishReasonStr = choice['finish_reason'] as String?;
      final finishReason = _parseFinishReason(finishReasonStr);

      final usage = Usage.fromJson(
        responseBody['usage'] as Map<String, dynamic>,
      );

      return GenerateTextResult(
        text: content,
        finishReason: finishReason,
        usage: usage,
        metadata: {
          'model': responseBody['model'],
          'created': responseBody['created'],
          'id': responseBody['id'],
        },
      );
    } catch (e) {
      if (e is AIException) rethrow;
      throw AIException('Failed to generate text: $e');
    }
  }

  FinishReason _parseFinishReason(String? reason) {
    switch (reason) {
      case 'stop':
        return FinishReason.stop;
      case 'length':
        return FinishReason.length;
      case 'model_length': // Mistral-specific
        return FinishReason.length;
      default:
        return FinishReason.other;
    }
  }

  void dispose() {
    _client.close();
  }
}
