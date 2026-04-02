import 'package:equatable/equatable.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/display_message.dart';

export 'display_message.dart';

/// Sentinel used by `SimulatorState.copyWith` to explicitly clear
/// `pendingPageIndex` to `null`.
const clearPendingPageIndex = -1;

/// Sentinel used by `SimulatorState.copyWith` to explicitly clear
/// `error` to `null`.
const clearError = '__clear_error__';

/// {@template simulator_state}
/// State for the simulator bloc.
/// {@endtemplate}
final class SimulatorState extends Equatable {
  /// {@macro simulator_state}
  const SimulatorState({
    this.status = SimulatorStatus.initial,
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.pendingPageIndex,
    this.showLoadingOverlay = false,
    this.error,
  });

  final SimulatorStatus status;

  /// Each page is a list of display messages shown on one full-screen step.
  final List<List<DisplayMessage>> pages;

  /// The index of the page currently being built by the AI.
  final int currentPageIndex;

  /// Whether the LLM is currently processing a request.
  final bool isLoading;

  /// The index of a page whose navigation has been deferred until the LLM
  /// finishes loading. When non-null, the current page stays visible (with its
  /// button's thinking animation) while the next page's content is being
  /// generated. The view uses this to show the outer thinking animation during
  /// the initial load.
  ///
  /// When loading completes, [currentPageIndex] is updated to this value and
  /// [pendingPageIndex] is cleared.
  final int? pendingPageIndex;

  /// Whether there is a deferred page navigation waiting to complete.
  bool get hasPendingNavigation => pendingPageIndex != null;

  /// Whether the full-screen loading overlay with the large Rive animation
  /// should be shown. Set to `true` when an AppButton with
  /// `showLoadingOverlay` is pressed, and cleared when the pending navigation
  /// completes.
  final bool showLoadingOverlay;

  final String? error;

  /// Returns a copy of this state with the given fields replaced.
  ///
  /// To clear [pendingPageIndex] to `null`, pass [clearPendingPageIndex].
  /// To clear [error] to `null`, pass [clearError].
  SimulatorState copyWith({
    SimulatorStatus? status,
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isLoading,
    int? pendingPageIndex,
    bool? showLoadingOverlay,
    String? error,
  }) {
    return SimulatorState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      pendingPageIndex: pendingPageIndex == clearPendingPageIndex
          ? null
          : pendingPageIndex ?? this.pendingPageIndex,
      showLoadingOverlay: showLoadingOverlay ?? this.showLoadingOverlay,
      error: error == clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pages,
    currentPageIndex,
    isLoading,
    pendingPageIndex,
    showLoadingOverlay,
    error,
  ];
}

enum SimulatorStatus { initial, loading, active, error }
