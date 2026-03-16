import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/gen/fonts.gen.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/intro/view/intro_page.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.profileType, super.key});

  final ProfileType profileType;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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
      appBar: _ChatAppBar(profileType: widget.profileType),
      body: BlocConsumer<ChatBloc, ChatState>(
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
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.pages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _FadingPageView(
                        controller: _pageController,
                        itemCount: state.pages.length,
                        itemBuilder: (context, pageIndex) {
                          final messages = state.pages[pageIndex];
                          return _ChatPage(
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

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.profileType});

  final ProfileType profileType;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  String get _profileLabel => switch (profileType) {
    ProfileType.beginner => 'The Beginner',
    ProfileType.optimizer => 'The Optimizer',
  };

  @override
  Widget build(BuildContext context) {
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
            _LogoIcon(gradient: gradient, size: isMobile ? 24 : 40),
            const SizedBox(width: Spacing.xs),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n.chatAppBarTitleFirstPart,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 18 : 24,
                      letterSpacing: isMobile ? -0.36 : -0.48,
                      color: const Color(0xFF232326),
                    ),
                  ),
                  TextSpan(
                    text: context.l10n.chatAppBarTitleSecondPart,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: isMobile ? 18 : 24,
                      letterSpacing: isMobile ? -0.36 : -0.48,
                      color: const Color(0xFF232326),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isMobile) ...[
              // Mobile: icon-only chips
              _IconChip(
                icon: Icons.person,
                borderColor: colors?.pinkColor ?? const Color(0xFFE98AD4),
                onTap: () {},
              ),
              const SizedBox(width: Spacing.xs),
              _IconChip(
                icon: Icons.refresh,
                gradient: gradient,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const IntroPage(),
                  ),
                ),
              ),
            ] else ...[
              // Desktop: labelled chips
              _GradientChip(
                gradient: gradient,
                icon: Icons.refresh,
                label: 'Restart Demo',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const IntroPage(),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              _ProfileChip(
                label: _profileLabel,
                backgroundColor:
                    colors?.pinkContainer ?? const Color(0x26E98AD4),
                textColor: colors?.onSurfaceVariant ?? const Color(0xFF5D5F5F),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon({required this.gradient, this.size = 40});

  final LinearGradient gradient;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = size / 40;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8.571 * scale),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 2.143 * scale,
        children: [
          Container(
            width: 5.833 * scale,
            height: 12.5 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.429 * scale),
            ),
          ),
          Container(
            width: 5 * scale,
            height: 16.667 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.429 * scale),
            ),
          ),
          Container(
            width: 5 * scale,
            height: 20.833 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.429 * scale),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientChip extends StatelessWidget {
  const _GradientChip({
    required this.gradient,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final LinearGradient gradient;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            SizedBox(
              height: 16,
              width: 24,
              child: FittedBox(
                child: Icon(icon, color: Colors.white),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1,
                letterSpacing: -0.15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: FittedBox(
              child: Icon(Icons.person, color: textColor),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.poppins,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1,
              letterSpacing: -0.15,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.icon,
    required this.onTap,
    this.gradient,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final LinearGradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Center(
          child: SizedBox(
            height: 16,
            width: 16,
            child: FittedBox(
              child: Icon(
                icon,
                color: gradient != null
                    ? Colors.white
                    : borderColor ?? Colors.black,
              ),
            ),
          ),
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

class _ChatPage extends StatefulWidget {
  const _ChatPage({
    required this.messages,
    required this.host,
    required this.isLoading,
  });

  final List<DisplayMessage> messages;
  final SurfaceHost host;
  final bool isLoading;

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage>
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
  void didUpdateWidget(_ChatPage oldWidget) {
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
                      ChatMessageBubble(
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
