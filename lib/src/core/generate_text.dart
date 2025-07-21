/// Core generateText function for the Dart AI SDK
library;

import 'ai_model.dart';
import 'types.dart';

/// Generate text using the specified model and options.
///
/// This is the main entry point for text generation, following the same
/// pattern as Vercel's AI SDK.
///
/// Example:
/// ```dart
/// final result = await generateText(
///   model: openai('gpt-4'),
///   prompt: 'Write a short poem about AI',
///   maxTokens: 100,
/// );
/// print(result.text);
/// ```
Future<GenerateTextResult> generateText({
  required AIModel model,
  required String prompt,
  int? maxTokens,
  double? temperature,
  double? topP,
  double? frequencyPenalty,
  double? presencePenalty,
  List<String>? stop,
  int? seed,
}) async {
  final options = GenerateTextOptions(
    prompt: prompt,
    maxTokens: maxTokens,
    temperature: temperature,
    topP: topP,
    frequencyPenalty: frequencyPenalty,
    presencePenalty: presencePenalty,
    stop: stop,
    seed: seed,
  );

  return await model.generateText(options);
}
