/// Mistral AI model implementations and convenience functions
library;

import '../../core/ai_model.dart';
import '../../core/types.dart';
import 'mistral_provider.dart';

/// Mistral AI model implementation
class MistralModel extends ProviderModel {
  @override
  final String modelId;

  @override
  final String provider = 'mistral';

  @override
  final String baseUrl;

  @override
  final String apiKey;

  @override
  final Map<String, String> headers;

  final MistralProvider _provider;

  MistralModel({required this.modelId, required ModelConfig config})
    : baseUrl = config.baseUrl ?? MistralProvider.defaultBaseUrl,
      apiKey = config.apiKey,
      headers = config.headers ?? {},
      _provider = MistralProvider(
        apiKey: config.apiKey,
        baseUrl: config.baseUrl ?? MistralProvider.defaultBaseUrl,
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

/// Convenience function to create Mistral AI models
///
/// Example:
/// ```dart
/// final model = mistral('mistral-large-latest', apiKey: 'your-api-key');
/// ```
MistralModel mistral(
  String modelId, {
  required String apiKey,
  String? baseUrl,
  Map<String, String>? headers,
  Duration? timeout,
}) {
  return MistralModel(
    modelId: modelId,
    config: ModelConfig(
      apiKey: apiKey,
      baseUrl: baseUrl,
      headers: headers,
      timeout: timeout,
    ),
  );
}
