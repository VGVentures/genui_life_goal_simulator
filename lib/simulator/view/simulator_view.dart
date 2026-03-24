import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:genui_life_goal_simulator/gen/fonts.gen.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/intro_page.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';

class SimulatorView extends StatefulWidget {
  const SimulatorView({required this.profileType, super.key});

  final ProfileType profileType;

  @override
  State<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends State<SimulatorView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColors>()?.surface,
      appBar: _SimulatorAppBar(profileType: widget.profileType),
      body: BlocConsumer<SimulatorBloc, SimulatorState>(
        listenWhen: (previous, current) =>
            previous.currentPageIndex != current.currentPageIndex,
        listener: (context, state) {
          if (_pageController.hasClients && state.pages.isNotEmpty) {
            if (mounted && _pageController.hasClients) {
              unawaited(
                _pageController.animateToPage(
                  state.currentPageIndex,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOutCubic,
                ),
              );
            }
          }
        },
        buildWhen: (previous, current) =>
            previous.pages != current.pages ||
            previous.host != current.host ||
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.pages.isEmpty || state.host == null
                    ? const Center(child: CircularProgressIndicator())
                    : _FadingPageView(
                        controller: _pageController,
                        itemCount: state.pages.length,
                        itemBuilder: (context, pageIndex) {
                          final messages = state.pages[pageIndex];
                          return _SimulatorPage(
                            messages: messages,
                            host: state.host!,
                            isLoading:
                                state.isLoading &&
                                pageIndex == state.currentPageIndex,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SimulatorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SimulatorAppBar({required this.profileType});

  final ProfileType profileType;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).extension<AppColors>();
    final gradient =
        colors?.geniusGradient ??
        const LinearGradient(
          colors: [Color(0xFF2461EB), Color(0xFFD4C6FB)],
        );
    final isMobile = Breakpoints.isMobile(
      MediaQuery.sizeOf(context).width,
    );

    return Container(
      decoration: responsiveValue<BoxDecoration?>(
        context,
        mobile: null,
        desktop: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: isMobile ? Spacing.md : Spacing.lg,
        right: isMobile ? Spacing.md : Spacing.lg,
        top: isMobile ? Spacing.lg : Spacing.sm,
        bottom: Spacing.xs,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo — smaller on mobile
            LogoIcon(size: isMobile ? 24 : 40),
            const SizedBox(width: Spacing.xs),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.chatAppBarTitleFirstPart,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 16 : 24,
                      letterSpacing: isMobile ? -0.36 : -0.48,
                      color: colors?.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: l10n.chatAppBarTitleSecondPart,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: isMobile ? 16 : 24,
                      letterSpacing: isMobile ? -0.36 : -0.48,
                      color: colors?.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ProfileChip(
              profileType: profileType,
              onTap: () {},
            ),
            const SizedBox(width: Spacing.sm),
            GradientChip(
              gradient: gradient,
              asset: Assets.images.advisor.restartIcon,
              label: !isMobile ? l10n.restartDemoLabel : null,
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => const IntroPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadingPageView extends StatelessWidget {
  const _FadingPageView({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
  });

  final PageController controller;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return PageView.builder(
          controller: controller,
          itemCount: itemCount,
          itemBuilder: (context, pageIndex) {
            // Calculate how far this page is from the current position.
            final currentPage =
                controller.hasClients &&
                    controller.position.hasContentDimensions
                ? controller.page ?? controller.initialPage.toDouble()
                : controller.initialPage.toDouble();
            final distance = (pageIndex - currentPage).abs();
            // Fade out aggressively — fully transparent at 50% scroll.
            final opacity = (1.0 - distance * 2).clamp(0.0, 1.0);
            // Arc downward along a cubic curve as the page scrolls away.
            final t = distance.clamp(0.0, 1.0);
            final curved = Curves.easeInCubic.transform(t);
            final yOffset = curved * 200;
            // Slight horizontal shift in the scroll direction for the arc.
            final direction = (pageIndex - currentPage).sign;
            final xOffset = curved * 30 * direction;

            return Transform.translate(
              offset: Offset(xOffset, yOffset),
              child: Opacity(
                opacity: opacity,
                child: itemBuilder(context, pageIndex),
              ),
            );
          },
        );
      },
    );
  }
}

class _SimulatorPage extends StatefulWidget {
  const _SimulatorPage({
    required this.messages,
    required this.host,
    required this.isLoading,
  });

  final List<DisplayMessage> messages;
  final SurfaceHost host;
  final bool isLoading;

  @override
  State<_SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<_SimulatorPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _contentOpacity;
  bool _hasFinishedLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _contentOpacity = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // If not loading from the start, show content immediately.
    if (!widget.isLoading) {
      _hasFinishedLoading = true;
      _fadeController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_SimulatorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Detect transition from loading → done.
    if (oldWidget.isLoading && !widget.isLoading && !_hasFinishedLoading) {
      _hasFinishedLoading = true;
      unawaited(_fadeController.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content — always laid out, visibility controlled by fade.
        FadeTransition(
          opacity: _contentOpacity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 100,
              left: Spacing.md,
              right: Spacing.md,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final message in widget.messages)
                    if (message is! UserDisplayMessage)
                      SimulatorMessageBubble(
                        message: message,
                        host: widget.host,
                      ),
                ],
              ),
            ),
          ),
        ),
        // Spinner — fades out as content fades in.
        if (widget.isLoading || !_hasFinishedLoading)
          AnimatedOpacity(
            opacity: _hasFinishedLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
