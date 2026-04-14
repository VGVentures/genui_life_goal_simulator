import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/simulator_state.dart';

/// Events for the simulator bloc.
sealed class SimulatorEvent {
  const SimulatorEvent();
}

/// The user completed onboarding and wants to start a conversation
final class SimulatorStarted extends SimulatorEvent {
  const SimulatorStarted({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
}

/// The user sent a text message
final class SimulatorMessageSent extends SimulatorEvent {
  const SimulatorMessageSent(this.text);

  final String text;
}

/// A surface was added or already exists — route to the correct page.
final class SimulatorSurfaceReceived extends SimulatorEvent {
  const SimulatorSurfaceReceived(this.surfaceId);

  final String surfaceId;
}

/// A display message was added to the current page.
final class SimulatorContentReceived extends SimulatorEvent {
  const SimulatorContentReceived(this.message);

  final DisplayMessage message;
}

/// Loading state when LLM is processing a request
final class SimulatorLoading extends SimulatorEvent {
  const SimulatorLoading({required this.isLoading});

  final bool isLoading;
}

/// The user pressed the back button to return to the previous step.
final class SimulatorBackPressed extends SimulatorEvent {
  const SimulatorBackPressed();
}

/// The back-navigation animation has finished — remove forward pages.
final class SimulatorForwardPagesTruncated extends SimulatorEvent {
  const SimulatorForwardPagesTruncated();
}

/// Request to show/hide the full-screen loading overlay animation.
final class SimulatorLoadingOverlayRequested extends SimulatorEvent {
  const SimulatorLoadingOverlayRequested();
}

/// An error occurred in the content generator
final class SimulatorErrorOccurred extends SimulatorEvent {
  const SimulatorErrorOccurred(this.message);

  final String message;
}

/// The user tapped "Try again" after an error — resume from last page.
final class SimulatorRetried extends SimulatorEvent {
  const SimulatorRetried();
}
