/// OpenAI model implementations and convenience functions
library;

import '../../core/ai_model.dart';
import '../../core/types.dart';
import 'openai_provider.dart';

/// OpenAI model implementation
class OpenAIModel extends ProviderModel {
  @override
  final String modelId;

  @override
  final String provider = 'openai';

  @override
  final String baseUrl;

  @override
  final String apiKey;

  @override
  final Map<String, String> headers;

  final OpenAIProvider _provider;

  OpenAIModel({required this.modelId, required ModelConfig config})
    : baseUrl = config.baseUrl ?? OpenAIProvider.defaultBaseUrl,
      apiKey = config.apiKey,
      headers = config.headers ?? {},
      _provider = OpenAIProvider(
        apiKey: config.apiKey,
        baseUrl: config.baseUrl ?? OpenAIProvider.defaultBaseUrl,
        headers: config.headers,
        timeout: config.timeout ?? const Duration(seconds: 60),
      );

  @override
  int? get maxTokens => null;

  @override
  bool get supportsStreaming => true;

  @override
  Future<GenerateTextResult> generateText(GenerateTextOptions options) {
    return _provider.generateText(modelId, options);
  }
}

/// Convenience function to create OpenAI models
///
/// Example:
/// ```dart
/// final model = openai('gpt-4', apiKey: 'your-api-key');
/// ```
OpenAIModel openai(
  String modelId, {
  required String apiKey,
  String? baseUrl,
  Map<String, String>? headers,
  Duration? timeout,
}) {
  return OpenAIModel(
    modelId: modelId,
    config: ModelConfig(
      apiKey: apiKey,
      baseUrl: baseUrl,
      headers: headers,
      timeout: timeout,
    ),
  );
}
