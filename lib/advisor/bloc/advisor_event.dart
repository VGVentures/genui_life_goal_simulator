import 'package:vgv_genui_financial_advisor/advisor/bloc/advisor_state.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/models/focus_option.dart';

/// Events for the advisor bloc.
sealed class AdvisorEvent {
  const AdvisorEvent();
}

/// The user completed onboarding and wants to start a conversation
final class AdvisorStarted extends AdvisorEvent {
  const AdvisorStarted({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
}

/// The user sent a text message
final class AdvisorMessageSent extends AdvisorEvent {
  const AdvisorMessageSent(this.text);

  final String text;
}

/// A surface was added or already exists — route to the correct page.
final class AdvisorSurfaceReceived extends AdvisorEvent {
  const AdvisorSurfaceReceived(this.surfaceId);

  final String surfaceId;
}

/// A display message was added to the current page.
final class AdvisorContentReceived extends AdvisorEvent {
  const AdvisorContentReceived(this.message);

  final DisplayMessage message;
}

/// Loading state when LLM is processing a request
final class AdvisorLoading extends AdvisorEvent {
  const AdvisorLoading({required this.isLoading});

  final bool isLoading;
}

/// An error occurred in the content generator
final class AdvisorErrorOccurred extends AdvisorEvent {
  const AdvisorErrorOccurred(this.message);

  final String message;
}
