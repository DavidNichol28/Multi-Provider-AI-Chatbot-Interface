# Chat Room (Multi-AI Provider Flutter App)
![pub package](https://img.shields.io/pub/v/chat_room.svg)

A modular Flutter chat application that supports multiple AI providers through a unified service abstraction layer. Built with Riverpod state management and designed for extensibility across different LLM APIs.

---

![target](https://img.shields.io/badge/runtime-local%20%2F%20hardware-blue)

⚠️ Runtime Target: Local / Hardware-Only Application

This project is designed to run on local hardware environments (Linux desktop / device-bound execution).

It is NOT intended for browser-based deployment due to direct client-side API usage and lack of CORS support from upstream AI providers.

A web-based demonstration layer is available here:
→ [ChatRoom Demo Repository](<https://github.com/DavidNichol28/DEMO-FOR-Multi-Provider-AI-Chatbot-Interface>)

Currently stable with **Anthropic (Claude)** and **Google (Gemini)** working.

---

## Basic Usage

Create a `.env` file:

```env
GOOGLE=your_google_api_key
ANTHROPIC=your_anthropic_api_key
```

Then create your app:

```dart
import 'package:flutter/material.dart';
import 'package:chat_room/chat_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatRoom Demo',
      home: ChatRoom(
        apiKeys: {
          "Google": dotenv.env['GOOGLE'] ?? '',
          "Anthropic": dotenv.env['ANTHROPIC'] ?? '',
        },
      ),
    );
  }
}
```

---

## Features

- Multi-provider AI support (architecture ready for):
  - Anthropic (Claude) ✅
  - Google Gemini ✅
- Unified AI service interface (`AiService`)
- Provider routing via enum-based system (`AiCompany`)
- Conversation management with persistence
- Local storage using `SharedPreferences`
- Riverpod-based reactive state management
- Modular UI components (navbar, chat feed, modals)
- Editable conversation titles
- Multi-conversation support

---

## Architecture Overview

The app is structured around a clean separation of concerns:

```
UI Layer
  └── ChatRoom / CustomNavBar / ChatFeed

State Layer (Riverpod)
  ├── ChatStateNotifier (conversations + messages)
  └── AiState / AiNotifier (provider selection + config)

Service Layer
  ├── AiService (request execution + API formatting)
  └── AiCompany (provider definitions)

Persistence Layer
  └── LocalMemoryService (SharedPreferences storage)
```

### Request Flow

```
User Input
   ↓
ChatStateNotifier
   ↓
AiState.currentService
   ↓
AiService.sendHandler()
   ↓
Provider API (Claude / Gemini / Meta)
```

---

## AI Provider System

AI providers are abstracted via:

```dart
enum AiCompany { google, anthropic, meta }
```

Each provider defines:
- API endpoint
- authentication headers
- request format
- response parsing

All logic is centralized in:

- `AiService.sendHandler()`
- `_buildRequestBody()`

---
## Current Provider Status

| Provider         | Status | Notes                    |
| ---------------- | ------ | ------------------------ |
| Anthropic Claude | ✅      | Working                  |
| Google Gemini    | ✅      | Working                  |


---

## State Management

### Chat State

Manages:
- Conversations
- Messages
- Active conversation index
- Persistence sync

```dart
ChatStateNotifier
```

---

### AI State

Manages:
- Active provider selection
- Available services
- Model configuration

```dart
AiNotifier → AiState
```

---

## Local Storage

Conversations are stored using `SharedPreferences`:

- JSON serialized
- Auto-loaded on startup
- Supports:
  - Add conversation
  - Update messages
  - Rename conversations
  - Delete conversations

---

## UI Components

### CustomNavBar
- Title widget
- Action buttons (modals, selectors)
- Editable conversation title
- Implements `PreferredSizeWidget`

### Chat Feed
- Scrollable message list
- Auto-scroll on updates
- User/AI message bubbles

### Input Handler
- Modular input widget
- Routes messages through state layer

---

## Configuration

### Environment Variables

Create a `.env` file:

```env
GOOGLE=your_google_api_key
ANTHROPIC=your_anthropic_api_key
META=your_meta_api_key
```

Load it in `main.dart`:

```dart
await dotenv.load(fileName: ".env");
```

---

## Known Issues

- Gemini API needs update after breaking changes
- Meta provider not fully configured
- Some debug logging still present
- Navbar may overflow on smaller screens

---

## Planned Improvements

- Streaming responses (token-by-token)
- Provider switching UI dropdown
- Fallback between AI providers
- Prompt templating system
- Better error handling + retry logic

---

## Tech Stack

- Flutter
- Riverpod
- HTTP
- SharedPreferences
- flutter_dotenv

---

## Design Philosophy

> A single chat UI that can route messages to multiple interchangeable AI backends without UI or business logic changes.

The goal is clean separation between:
- UI
- State
- Transport (AI APIs)

---

## License

Personal / experimental project.
```
