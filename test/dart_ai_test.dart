import 'package:dart_ai/dart_ai.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Mock HTTP client for testing
class MockClient extends http.BaseClient {
  final Map<String, dynamic> mockResponse;
  final int statusCode;

  MockClient({required this.mockResponse, this.statusCode = 200});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = http.Response(
      json.encode(mockResponse),
      statusCode,
      headers: {'content-type': 'application/json'},
    );

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  group('Dart AI SDK Tests', () {
    test('generateText with OpenAI model', () async {
      // Create test models
      final openaiModel = OpenAIModel(
        modelId: 'gpt-3.5-turbo',
        config: ModelConfig(apiKey: 'test-key'),
      );

      final mistralModel = MistralModel(
        modelId: 'mistral-small-latest',
        config: ModelConfig(apiKey: 'test-key'),
      );

      final options = GenerateTextOptions(
        prompt: 'Hello!',
        maxTokens: 50,
        temperature: 0.7,
      );

      // Test OpenAI model interface
      expect(openaiModel.modelId, equals('gpt-3.5-turbo'));
      expect(openaiModel.provider, equals('openai'));
      expect(openaiModel.supportsStreaming, isTrue);

      // Test Mistral model interface
      expect(mistralModel.modelId, equals('mistral-small-latest'));
      expect(mistralModel.provider, equals('mistral'));
      expect(mistralModel.supportsStreaming, isTrue);

      // Test options
      expect(options.prompt, equals('Hello!'));
      expect(options.maxTokens, equals(50));
      expect(options.temperature, equals(0.7));
    });

    test('Usage class JSON serialization', () {
      const usage = Usage(
        promptTokens: 10,
        completionTokens: 15,
        totalTokens: 25,
      );

      final json = usage.toJson();
      expect(json['prompt_tokens'], equals(10));
      expect(json['completion_tokens'], equals(15));
      expect(json['total_tokens'], equals(25));

      final usageFromJson = Usage.fromJson(json);
      expect(usageFromJson.promptTokens, equals(10));
      expect(usageFromJson.completionTokens, equals(15));
      expect(usageFromJson.totalTokens, equals(25));
    });

    test('AIException formatting', () {
      const exception = AIException(
        'Test error message',
        code: 'test_code',
        details: {'key': 'value'},
      );

      expect(exception.message, equals('Test error message'));
      expect(exception.code, equals('test_code'));
      expect(exception.details, equals({'key': 'value'}));
      expect(exception.toString(), contains('Test error message'));
      expect(exception.toString(), contains('test_code'));
    });
    test('Model token limits', () {
      // All models should return null for maxTokens
      final gpt4 = openai('gpt-4', apiKey: 'test-key');
      final gpt35 = openai('gpt-3.5-turbo', apiKey: 'test-key');
      final gpt4Turbo = openai('gpt-4-1106-preview', apiKey: 'test-key');

      expect(gpt4.maxTokens, isNull);
      expect(gpt35.maxTokens, isNull);
      expect(gpt4Turbo.maxTokens, isNull);

      // Mistral models
      final mistralLarge = mistral('mistral-large-latest', apiKey: 'test-key');
      final mistralSmall = mistral('mistral-small-latest', apiKey: 'test-key');
      final openMixtral8x22B = mistral(
        'open-mixtral-8x22b',
        apiKey: 'test-key',
      );

      expect(mistralLarge.maxTokens, isNull);
      expect(mistralSmall.maxTokens, isNull);
      expect(openMixtral8x22B.maxTokens, isNull);

      // Gemini models
      final geminiPro = gemini('gemini-pro', apiKey: 'test-key');
      final geminiPro15 = gemini('gemini-1.5-pro', apiKey: 'test-key');
      final geminiFlash15 = gemini('gemini-1.5-flash', apiKey: 'test-key');

      expect(geminiPro.maxTokens, isNull);
      expect(geminiPro15.maxTokens, isNull);
      expect(geminiFlash15.maxTokens, isNull);
    });
  });
}
