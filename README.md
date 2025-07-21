# dart_ai - the extendable AI toolkit for Dart

> [!IMPORTANT]
> The API is not stable yet and may be subject to change.

Extendable AI toolkit for Dart, providing a clean and type-safe interface for working with AI language models, inspired by [Vercel's AI SDK for TypeScript](https://ai-sdk.dev/).

## Features

- 🚀 **Simple API** - Clean, intuitive interface similar to Vercel's AI SDK
- 🔧 **Provider Pattern** - Extensible architecture for multiple AI providers
- 🎯 **Type Safe** - Full Dart type safety and null safety

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  dart_ai: ^1.0.0
  http: ^1.2.0
```

## Quick Start

```dart
import 'package:dart_ai/dart_ai.dart';

Future<void> main() async {
  // OpenAI example
  final openaiModel = openai('gpt-3.5-turbo', apiKey: 'your-openai-key');
  
  // Mistral example
  final mistralModel = mistral('mistral-small-latest', apiKey: 'your-mistral-key');
  
  // Gemini example
  final geminiModel = gemini('gemini-1.5-flash', apiKey: 'your-gemini-key');
  
  // Generate text with any provider
  final result = await generateText(
    model: geminiModel, // or openaiModel, mistralModel
    prompt: 'Write a haiku about programming',
    maxTokens: 100,
    temperature: 0.7,
  );
  
  print(result.text);
  print('Used ${result.usage.totalTokens} tokens');
}
```

## Usage

### Using Models

Models expose their respective function constructors.

```dart
// Using the convenience function
final model = openai('gpt-4', apiKey: 'your-api-key');

// With custom configuration
final customModel = openai(
  'gpt-4',
  apiKey: 'your-api-key',
  baseUrl: 'https://your-custom-endpoint.com/v1',
  headers: {'Custom-Header': 'value'},
  timeout: Duration(seconds: 30),
);
```

#### Mistral AI Models

```dart
// Using the convenience function
final model = mistral('mistral-large-latest', apiKey: 'your-mistral-key');
```

#### Google Gemini Models

```dart
// Using the convenience function
final model = gemini('gemini-1.5-flash', apiKey: 'your-gemini-key');
```

### Generating Text

```dart
final result = await generateText(
  model: model,
  prompt: 'Your prompt here',
  maxTokens: 150,           // Optional: limit response length
  temperature: 0.7,         // Optional: creativity (0.0-2.0)
  topP: 0.9,               // Optional: nucleus sampling
  frequencyPenalty: 0.0,    // Optional: reduce repetition
  presencePenalty: 0.0,     // Optional: encourage new topics
  stop: ['END'],            // Optional: stop sequences
  seed: 42,                // Optional: deterministic results
);

print('Generated: ${result.text}');
print('Finish reason: ${result.finishReason}');
print('Tokens used: ${result.usage.totalTokens}');
```

### Working with Results

```dart
final result = await generateText(
  model: model,
  prompt: 'Explain quantum computing',
);

// Access the generated text
print(result.text);

// Check why generation stopped
switch (result.finishReason) {
  case FinishReason.stop:
    print('Natural completion');
    break;
  case FinishReason.length:
    print('Hit token limit');
    break;
  case FinishReason.contentFilter:
    print('Content was filtered');
    break;
  // ... other cases
}

// Usage statistics
print('Prompt tokens: ${result.usage.promptTokens}');
print('Completion tokens: ${result.usage.completionTokens}');
print('Total tokens: ${result.usage.totalTokens}');

// Additional metadata (provider-specific)
print('Model: ${result.metadata?['model']}');
print('Request ID: ${result.metadata?['id']}');
```

### Error Handling

```dart
try {
  final result = await generateText(
    model: model,
    prompt: 'Your prompt',
  );
  print(result.text);
} catch (e) {
  if (e is AIException) {
    print('AI Error: ${e.message}');
    if (e.code != null) {
      print('Error code: ${e.code}');
    }
    print('Details: ${e.details}');
  } else {
    print('Unexpected error: $e');
  }
}
```

## Running an Example Application

There's a basic command-line chat application in the [example/chat_cli](example/chat_cli) directory that supports different AI providers and models. See the [README](example/chat_cli/README.md) for more details.

## Running Tests

```bash
dart test
```

## Supported Models

Currently the only supported models are OpenAI, Google Gemini and Mistral AI. You are welcome to contribute to the project and add more models.

### OpenAI
- `gpt-4` - GPT-4
- `gpt-4-32k` - GPT-4 (32k context)
- `gpt-4-1106-preview` - GPT-4 Turbo
- `gpt-3.5-turbo` - GPT-3.5 Turbo
- `gpt-3.5-turbo-16k` - GPT-3.5 Turbo (16k context)

### Mistral AI
- `mistral-large-latest` - Most capable model
- `mistral-medium-latest` - Balanced performance
- `mistral-small-latest` - Fast and efficient
- `open-mistral-7b` - Open source 7B model
- `open-mixtral-8x7b` - Open source mixture of experts
- `open-mixtral-8x22b` - Larger mixture of experts
- `codestral-latest` - Specialized for code generation

### Google Gemini
- `gemini-1.5-pro` - Latest and most capable model
- `gemini-1.5-flash` - Fast and efficient model
- `gemini-pro` - Legacy model
- `gemini-pro-vision` - Multimodal model (text + images)

## Architecture

The SDK follows a function model with AI providers and their models, similar to Vercel's AI SDK:

- **AIModel** - Abstract base class for all models
- **ProviderModel** - Base class for provider-specific models
- **generateText()** - Main function for text generation
- **GenerateTextOptions** - Configuration for text generation
- **GenerateTextResult** - Structured result with text, usage, and metadata

## To Do

The following features are planned to be implemented in the future:
- [ ] Streaming support.
- [ ] Support for other AI providers.
- [ ] Flutter UI helpers for chat apps.
- [ ] `flutter_hooks` support for `useChat` hook.
- [ ] Moving providers into their own separate packages.

## Contributing

Contributions to the project are welcome! Feel free to open issues and to submit a Pull Request after discussing the changes in an issue.

## AI-generated Code Disclaimer

Parts of this project, particularly some of the configuration for individual models, were created with the help of generative AI tools so inaccuracies are possible. Please open issues or pull requests if you find any.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
