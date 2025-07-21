/// Google Gemini model implementations and convenience functions
library;

import '../../core/ai_model.dart';
import '../../core/types.dart';
import 'gemini_provider.dart';

/// Google Gemini model implementation
class GeminiModel extends ProviderModel {
  @override
  final String modelId;

  @override
  final String provider = 'gemini';

  @override
  final String baseUrl;

  @override
  final String apiKey;

  @override
  final Map<String, String> headers;

  final GeminiProvider _provider;

  GeminiModel({required this.modelId, required ModelConfig config})
    : baseUrl = config.baseUrl ?? GeminiProvider.defaultBaseUrl,
      apiKey = config.apiKey,
      headers = config.headers ?? {},
      _provider = GeminiProvider(
        apiKey: config.apiKey,
        baseUrl: config.baseUrl ?? GeminiProvider.defaultBaseUrl,
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

/// Convenience function to create Google Gemini models
///
/// Example:
/// ```dart
/// final model = gemini('gemini-pro', apiKey: 'your-api-key');
/// ```
GeminiModel gemini(
  String modelId, {
  required String apiKey,
  String? baseUrl,
  Map<String, String>? headers,
  Duration? timeout,
}) {
  return GeminiModel(
    modelId: modelId,
    config: ModelConfig(
      apiKey: apiKey,
      baseUrl: baseUrl,
      headers: headers,
      timeout: timeout,
    ),
  );
}

/// Convenience functions for common Google Gemini models
class Gemini {
  /// Gemini 1.5 Pro - Latest and most capable model (1M context)
  static GeminiModel pro15({
    required String apiKey,
    String? baseUrl,
    Map<String, String>? headers,
    Duration? timeout,
  }) => gemini(
    'gemini-1.5-pro',
    apiKey: apiKey,
    baseUrl: baseUrl,
    headers: headers,
    timeout: timeout,
  );

  /// Gemini 1.5 Flash - Fast and efficient model (1M context)
  static GeminiModel flash15({
    required String apiKey,
    String? baseUrl,
    Map<String, String>? headers,
    Duration? timeout,
  }) => gemini(
    'gemini-1.5-flash',
    apiKey: apiKey,
    baseUrl: baseUrl,
    headers: headers,
    timeout: timeout,
  );

  /// Gemini Pro - Legacy model (32K context)
  static GeminiModel pro({
    required String apiKey,
    String? baseUrl,
    Map<String, String>? headers,
    Duration? timeout,
  }) => gemini(
    'gemini-pro',
    apiKey: apiKey,
    baseUrl: baseUrl,
    headers: headers,
    timeout: timeout,
  );

  /// Gemini Pro Vision - Multimodal model (text + images)
  static GeminiModel proVision({
    required String apiKey,
    String? baseUrl,
    Map<String, String>? headers,
    Duration? timeout,
  }) => gemini(
    'gemini-pro-vision',
    apiKey: apiKey,
    baseUrl: baseUrl,
    headers: headers,
    timeout: timeout,
  );
}
