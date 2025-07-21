/// Google Gemini provider implementation
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/types.dart';

/// Google Gemini API client
class GeminiProvider {
  static const String defaultBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  final String apiKey;
  final String baseUrl;
  final Map<String, String> headers;
  final Duration timeout;
  final http.Client _client;

  GeminiProvider({
    required this.apiKey,
    this.baseUrl = defaultBaseUrl,
    Map<String, String>? headers,
    this.timeout = const Duration(seconds: 60),
    http.Client? client,
  }) : headers = {'Content-Type': 'application/json', ...?headers},
       _client = client ?? http.Client();

  /// Generate text completion using Gemini API
  Future<GenerateTextResult> generateText(
    String modelId,
    GenerateTextOptions options,
  ) async {
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': options.prompt},
          ],
        },
      ],
      'generationConfig': {
        if (options.maxTokens != null) 'maxOutputTokens': options.maxTokens,
        if (options.temperature != null) 'temperature': options.temperature,
        if (options.topP != null) 'topP': options.topP,
        if (options.stop != null && options.stop!.isNotEmpty)
          'stopSequences': options.stop,
        'candidateCount': 1,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
        },
      ],
    };

    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/models/$modelId:generateContent?key=$apiKey'),
            headers: headers,
            body: json.encode(requestBody),
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        final errorBody = json.decode(response.body) as Map<String, dynamic>;
        final error = errorBody['error'] as Map<String, dynamic>?;

        throw AIException(
          error?['message'] ?? 'Gemini API request failed',
          code: error?['code']?.toString(),
          details: {
            'status_code': response.statusCode,
            'response_body': errorBody,
          },
        );
      }

      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      final candidates = responseBody['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw const AIException('No candidates returned from Gemini API');
      }

      final candidate = candidates.first as Map<String, dynamic>;
      final content = candidate['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;

      if (parts.isEmpty) {
        throw const AIException('No content parts returned from Gemini API');
      }

      final textPart = parts.first as Map<String, dynamic>;
      final text = textPart['text'] as String? ?? '';

      final finishReasonStr = candidate['finishReason'] as String?;
      final finishReason = _parseFinishReason(finishReasonStr);

      // Gemini doesn't provide detailed token usage in the same format
      // We'll estimate based on text length (rough approximation)
      final estimatedTokens = _estimateTokens(options.prompt, text);
      final usage = Usage(
        promptTokens: estimatedTokens['prompt']!,
        completionTokens: estimatedTokens['completion']!,
        totalTokens: estimatedTokens['total']!,
      );

      return GenerateTextResult(
        text: text,
        finishReason: finishReason,
        usage: usage,
        metadata: {'model': modelId, 'candidate_count': candidates.length},
      );
    } catch (e) {
      if (e is AIException) rethrow;
      throw AIException('Failed to generate text: $e');
    }
  }

  FinishReason _parseFinishReason(String? reason) {
    switch (reason) {
      case 'STOP':
        return FinishReason.stop;
      case 'MAX_TOKENS':
        return FinishReason.length;
      case 'SAFETY':
        return FinishReason.contentFilter;
      case 'RECITATION':
        return FinishReason.other;
      default:
        return FinishReason.other;
    }
  }

  /// Rough token estimation (Gemini doesn't provide exact counts)
  Map<String, int> _estimateTokens(String prompt, String response) {
    // Rough estimation: ~4 characters per token
    final promptTokens = (prompt.length / 4).round();
    final completionTokens = (response.length / 4).round();
    final totalTokens = promptTokens + completionTokens;

    return {
      'prompt': promptTokens,
      'completion': completionTokens,
      'total': totalTokens,
    };
  }

  void dispose() {
    _client.close();
  }
}
