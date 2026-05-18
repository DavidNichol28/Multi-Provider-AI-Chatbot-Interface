# Chat Room (Multi-AI Provider Flutter App)

A modular Flutter chat application that supports multiple AI providers through a unified service abstraction layer. Built with Riverpod state management and designed for extensibility across different LLM APIs.

Currently stable with **Anthropic (Claude)** working. Google Gemini and Meta providers are present but may require API updates.

---

## Features

- Multi-provider AI support (architecture ready for):
  - Anthropic (Claude) ✅
  - Google Gemini ⚠️ (API may need update)
  - Meta LLaMA ⚠️ (not fully configured)
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

| Provider     | Status | Notes |
|--------------|--------|------|
| Anthropic    | ✅     | Fully working (Claude 3.5 Sonnet) |
| Google       | ⚠️     | Requires API compatibility update |
| Meta         | ⚠️     | Placeholder endpoint / model config incomplete |

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
