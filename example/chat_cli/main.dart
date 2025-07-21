import 'dart:io';
import 'package:dart_ai/dart_ai.dart';

Future<void> main(List<String> arguments) async {
  print('🤖 dart_ai Chat\n');

  // Get provider from arguments or auto-detect
  String? provider = arguments.firstOrNull?.toLowerCase();
  if (provider == null) {
    print('Usage: dart run example/chat_cli/main.dart [openai|mistral|gemini]');
    exit(1);
  }
  if (!['openai', 'mistral', 'gemini'].contains(provider)) {
    print('Usage: dart run example/chat_cli/main.dart [openai|mistral|gemini]');
    exit(1);
  }
  final modelId = arguments.elementAtOrNull(1);

  // Create model
  final model = _createModel(provider, modelId);
  print('Using ${model.provider}: ${model.modelId}\n');

  // Simple chat loop
  while (true) {
    stdout.write('You: ');
    final input = stdin.readLineSync()?.trim();

    if (input == null || input.isEmpty) continue;
    if (input == 'quit' || input == 'exit') break;

    try {
      final result = await generateText(
        model: model,
        prompt: input,
        maxTokens: 300,
      );

      print('AI: ${result.text.trim()}');
      print('Tokens: ${result.usage.totalTokens}\n');
    } catch (e) {
      print('Error: $e\n');
    }
  }

  print('Goodbye!');
}

AIModel _createModel(String provider, String? modelId) {
  final apiKeyEnv = '${provider.toUpperCase()}_API_KEY';
  final apiKey = Platform.environment[apiKeyEnv];
  switch (provider) {
    case 'openai':
      if (apiKey == null) throw Exception('$apiKeyEnv not set');
      return openai(modelId ?? 'gpt-3.5-turbo', apiKey: apiKey);

    case 'mistral':
      if (apiKey == null) throw Exception('$apiKeyEnv not set');
      return mistral(modelId ?? 'mistral-small-latest', apiKey: apiKey);

    case 'gemini':
      if (apiKey == null) throw Exception('$apiKeyEnv not set');
      return gemini(modelId ?? 'gemini-1.5-flash', apiKey: apiKey);

    default:
      throw Exception('Unknown provider: $provider');
  }
}
