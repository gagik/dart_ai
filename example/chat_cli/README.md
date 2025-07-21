# Simple Chat App Example

A basic interactive chat application using the Dart AI SDK.

## Features

- Simple command-line chat interface
- Support for OpenAI and Mistral AI
- Auto-detection of available API keys
- Basic token usage tracking
- Easy to use and understand

## Usage

### Setup

Set the appropriate API key as an environment variable:

```bash
# For OpenAI
export OPENAI_API_KEY="your-openai-api-key"

# For Mistral
export MISTRAL_API_KEY="your-mistral-api-key"

# For Gemini
export GEMINI_API_KEY="your-gemini-api-key"
```

### Running

```bash
# Specify provider (and model if wanted)
dart run example/chat_cli/main.dart openai
dart run example/chat_cli/main.dart mistral
dart run example/chat_cli/main.dart gemini gemini-1.5-flash
```

### Commands

- Type your message and press Enter
- Type `quit` or `exit` to end the chat (or just press Ctrl+C)
- Empty messages are ignored

## Example Session

```
🤖 Dart AI Chat

Using openai: gpt-3.5-turbo

You: Hello! How are you?
AI: Hello! I'm doing well, thank you for asking. I'm here and ready to help you with any questions or tasks you might have. How can I assist you today?
Tokens: 35

You: What's 2+2?
AI: 2+2 equals 4.
Tokens: 8

You: quit
Goodbye!
```

## Code Structure

- `main.dart` - Single file containing the entire chat application
- Simple provider selection and model creation
- Basic input/output loop with error handling 