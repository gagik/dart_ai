/// AI model interfaces and base classes
library;

import 'types.dart';

/// Abstract base class for AI models
abstract class AIModel {
  /// Model identifier (e.g., 'gpt-4', 'claude-3-opus')
  String get modelId;

  /// Provider name (e.g., 'openai', 'anthropic')
  String get provider;

  /// Maximum context length in tokens
  int? get maxTokens;

  /// Whether the model supports streaming
  bool get supportsStreaming;

  const AIModel();

  /// Generate text using this model
  Future<GenerateTextResult> generateText(GenerateTextOptions options);

  @override
  String toString() => '$provider:$modelId';
}

/// Base class for provider-specific models
abstract class ProviderModel extends AIModel {
  /// API endpoint base URL
  String get baseUrl;

  /// API key for authentication
  String get apiKey;

  /// Additional headers to send with requests
  Map<String, String> get headers;

  const ProviderModel();
}

/// Model configuration for provider models
class ModelConfig {
  /// API key
  final String apiKey;

  /// Base URL (optional, uses provider default if not specified)
  final String? baseUrl;

  /// Additional headers
  final Map<String, String>? headers;

  /// Request timeout
  final Duration? timeout;

  const ModelConfig({
    required this.apiKey,
    this.baseUrl,
    this.headers,
    this.timeout,
  });
}
