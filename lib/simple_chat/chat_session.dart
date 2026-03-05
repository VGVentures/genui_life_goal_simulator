// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:dartantic_ai/dartantic_ai.dart' as dartantic;
import 'package:finance_app/simple_chat/ai_client.dart';
import 'package:finance_app/simple_chat/catalog/bar_chart.dart';
import 'package:finance_app/simple_chat/catalog/compact_hero.dart';
import 'package:finance_app/simple_chat/catalog/compact_info_card.dart';
import 'package:finance_app/simple_chat/catalog/container_item.dart';
import 'package:finance_app/simple_chat/catalog/dashboard.dart';
import 'package:finance_app/simple_chat/catalog/stat_column.dart';
import 'package:finance_app/simple_chat/catalog/stat_row.dart';
import 'package:finance_app/simple_chat/catalog/wide_hero.dart';
import 'package:finance_app/simple_chat/catalog/wide_info_panel.dart';
import 'package:finance_app/simple_chat/message.dart';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart';

/// A class that manages the chat session state and logic.
class ChatSession extends ChangeNotifier {
  ChatSession({required AiClient aiClient, required double screenWidth})
    : _aiClient = aiClient,
      _screenWidth = screenWidth {
    _init();
  }

  final AiClient _aiClient;
  final double _screenWidth;

  final List<Message> _messages = [];
  List<Message> get messages => List.unmodifiable(_messages);

  late final SurfaceController _surfaceController;
  SurfaceHost get surfaceController => _surfaceController;

  late final A2uiTransportAdapter _transportAdapter;
  A2uiTransportAdapter get transportAdapter => _transportAdapter;

  final List<dartantic.ChatMessage> _chatHistory = [];

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void _init() {
    final catalog = BasicCatalogItems.asCatalog()
        .copyWithout(itemsToRemove: [BasicCatalogItems.textField])
        .copyWith(
          newItems: [
            barChart,
            compactHero,
            compactInfoCard,
            containerItem,
            dashboard,
            statColumn,
            statRow,
            wideHero,
            wideInfoPanel,
          ],
        );

    // Initialize Message Processor
    _surfaceController = SurfaceController(catalogs: [catalog]);

    // Initialize A2uiTransportAdapter
    _transportAdapter = A2uiTransportAdapter();

    // Wire controller to processor
    _transportAdapter.incomingMessages.listen(_surfaceController.handleMessage);

    // Listen to UI state updates from the processor
    _surfaceController.surfaceUpdates.listen((SurfaceUpdate update) {
      if (update is SurfaceAdded) {
        // Check if we already have a message with this surfaceId
        final bool exists = _messages.any(
          (m) => m.surfaceId == update.surfaceId,
        );

        if (!exists) {
          _messages.add(
            Message(isUser: false, text: null, surfaceId: update.surfaceId),
          );
          notifyListeners();
        }
      }
    });

    // Listen to client events (interactions) from the UI
    _surfaceController.onSubmit.listen(_handleChatMessage);

    final deviceType = _screenWidth < 600 ? 'mobile' : 'desktop';

    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      instructions:
          '''
You are a helpful assistant who chats with a user.
Your responses should contain acknowledgment of the user message.

## Device Context
Device type: $deviceType.

Adapt your widget choices based on the device type. Each component's schema
description specifies which device types it is designed for.

## Interactivity
Prefer interactive widgets when appropriate. Use Slider for numeric ranges,
ChoicePicker for selecting from options, CheckBox for toggles, and Button
for actions. These let the user engage with the content directly rather
than just reading it.

## Dashboard
When presenting data alongside controls, use the Dashboard component.
It combines a visualization (like a BarChart) with interactive controls
(like Sliders or ChoicePickers) in a responsive layout that adapts to
the device type automatically.

## Container
Use the Container component to visually group related widgets with a
styled box. It supports background colors, borders, border radius, and
padding. Place child widget IDs inside childIds. Containers can be nested
to create complex layouts with distinct visual sections.
''',
    );

    // Add system instruction to history
    _chatHistory.add(dartantic.ChatMessage.system(promptBuilder.systemPrompt));
  }

  void _handleChatMessage(ChatMessage event) {
    genUiLogger.info('Received chat message: ${event.toJson()}');
    final buffer = StringBuffer();
    for (final dartantic.StandardPart part in event.parts) {
      if (part.isUiInteractionPart) {
        buffer.write(part.asUiInteractionPart!.interaction);
      } else if (part is TextPart) {
        buffer.write(part.text);
      }
    }
    final text = buffer.toString();
    if (text.isNotEmpty) {
      _sendInteraction(text);
    }
  }

  Future<void> _sendInteraction(String text) async {
    _chatHistory.add(dartantic.ChatMessage.user(text));
    await _performGeneration(text);
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    _messages.add(Message(isUser: true, text: 'You: $text'));
    _chatHistory.add(dartantic.ChatMessage.user(text));

    await _performGeneration(text);
  }

  Future<void> _performGeneration(String prompt) async {
    _isProcessing = true;
    notifyListeners();

    try {
      var fullResponseText = '';

      // Create a message controller for the AI response
      final aiMessageController = Message(isUser: false, text: 'AI: ');
      _messages.add(aiMessageController);
      notifyListeners();

      // Listen for text updates from the controller to update the UI
      final StreamSubscription<String> subscription = _transportAdapter
          .incomingText
          .listen((chunk) {
            aiMessageController.text = (aiMessageController.text ?? '') + chunk;
            notifyListeners();
          });

      // Use sendStream() to receive chunks of the response.
      final Stream<String> stream = _aiClient.sendStream(
        prompt,
        history: List.of(_chatHistory),
      );

      await for (final String chunk in stream) {
        if (chunk.isNotEmpty) {
          fullResponseText += chunk;
          _transportAdapter.addChunk(chunk);
        }
      }

      await subscription.cancel();

      _chatHistory.add(dartantic.ChatMessage.model(fullResponseText));
    } catch (exception, stackTrace) {
      genUiLogger.severe('Error generating content', exception, stackTrace);
      // We might want to expose errors via a listener or separate stream
      // For now, let's just log it. In a real app, we'd handle error states.
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _surfaceController.dispose();
    _transportAdapter.dispose();
    _aiClient.dispose();
    super.dispose();
  }
}
