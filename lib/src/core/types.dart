/// Core types for the Dart AI SDK
library;

/// Represents the reason why text generation finished
enum FinishReason {
  /// Natural stop
  stop,

  /// Reached maximum length
  length,

  /// Content was filtered
  contentFilter,

  /// Tool calls were made
  toolCalls,

  /// Generation was cancelled
  cancelled,

  /// Other/unknown reason
  other,
}

/// Usage statistics for a completion
class Usage {
  /// Number of tokens in the prompt
  final int promptTokens;

  /// Number of tokens in the completion
  final int completionTokens;

  /// Total number of tokens used
  final int totalTokens;

  const Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'] as int,
      completionTokens: json['completion_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}

/// Options for text generation
class GenerateTextOptions {
  /// The input prompt/messages
  final String prompt;

  /// Maximum number of tokens to generate
  final int? maxTokens;

  /// Temperature for randomness (0.0 to 2.0)
  final double? temperature;

  /// Top-p sampling parameter
  final double? topP;

  /// Frequency penalty
  final double? frequencyPenalty;

  /// Presence penalty
  final double? presencePenalty;

  /// Stop sequences
  final List<String>? stop;

  /// Random seed for deterministic results
  final int? seed;

  const GenerateTextOptions({
    required this.prompt,
    this.maxTokens,
    this.temperature,
    this.topP,
    this.frequencyPenalty,
    this.presencePenalty,
    this.stop,
    this.seed,
  });
}

/// Result from text generation
class GenerateTextResult {
  /// Generated text content
  final String text;

  /// Reason generation finished
  final FinishReason finishReason;

  /// Token usage statistics
  final Usage usage;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  const GenerateTextResult({
    required this.text,
    required this.finishReason,
    required this.usage,
    this.metadata,
  });
}

/// Exception thrown when AI generation fails
class AIException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const AIException(this.message, {this.code, this.details});

  @override
  String toString() {
    return 'AIException: $message${code != null ? ' (code: $code)' : ''}';
  }
}
