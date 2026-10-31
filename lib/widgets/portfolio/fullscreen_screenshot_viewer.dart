import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

/// Full-screen screenshot gallery viewer supporting zoom, swipe gestures,
/// keyboard arrow navigation, counter indicator, and forward/backward buttons.
class FullScreenScreenshotViewer extends StatefulWidget {
  final List<String> screenshots;
  final int initialIndex;

  const FullScreenScreenshotViewer({
    super.key,
    required this.screenshots,
    this.initialIndex = 0,
  });

  static void show({
    required BuildContext context,
    required List<String> screenshots,
    int initialIndex = 0,
  }) {
    if (screenshots.isEmpty) return;

    Get.dialog(
      FullScreenScreenshotViewer(
        screenshots: screenshots,
        initialIndex: initialIndex,
      ),
      barrierColor: Colors.black.withValues(alpha: 0.94),
      barrierDismissible: true,
      useSafeArea: false,
    );
  }

  @override
  State<FullScreenScreenshotViewer> createState() =>
      _FullScreenScreenshotViewerState();
}

class _FullScreenScreenshotViewerState
    extends State<FullScreenScreenshotViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.screenshots.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (widget.screenshots.length <= 1) return;
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _pageController.animateToPage(
        widget.screenshots.length - 1,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToNext() {
    if (widget.screenshots.length <= 1) return;
    if (_currentIndex < widget.screenshots.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _goToPrevious();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _goToNext();
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMultiple = widget.screenshots.length > 1;
    final double buttonSideMargin = AppScale.isMobile ? 12.0 : 28.0;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.94),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Swipable & Zoomable Image PageView
              PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.screenshots.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final asset = widget.screenshots[index];
                  return InteractiveViewer(
                    maxScale: 4.0,
                    minScale: 0.8,
                    clipBehavior: Clip.none,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppScale.isMobile ? 16.0 : 64.0,
                          vertical: AppScale.isMobile ? 48.0 : 64.0,
                        ),
                        child: Image.asset(
                          asset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 2. Backward Navigation Button (Left Side)
              if (hasMultiple)
                Positioned(
                  left: buttonSideMargin,
                  child: _GalleryNavButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: 'Previous Image',
                    onPressed: _goToPrevious,
                  ),
                ),

              // 3. Forward Navigation Button (Right Side)
              if (hasMultiple)
                Positioned(
                  right: buttonSideMargin,
                  child: _GalleryNavButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    tooltip: 'Next Image',
                    onPressed: _goToNext,
                  ),
                ),

              // 4. Close Button (Top Right)
              Positioned(
                top: AppScale.isMobile ? 20.0 : 28.0,
                right: AppScale.isMobile ? 16.0 : 28.0,
                child: SafeArea(
                  child: _GalleryNavButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Close Viewer',
                    onPressed: () => Get.back(),
                  ),
                ),
              ),

              // 5. Image Counter Indicator Pill (Bottom Center)
              if (hasMultiple)
                Positioned(
                  bottom: AppScale.isMobile ? 24.0 : 36.0,
                  child: SafeArea(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppScale.w(16),
                            vertical: AppScale.h(8),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.35),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: AppScale.icon(14),
                                color: AppColors.accent,
                              ),
                              SizedBox(width: AppScale.w(8)),
                              Text(
                                '${_currentIndex + 1} / ${widget.screenshots.length}',
                                style: AppTextStyles.mono12.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppScale.font(12),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating glassmorphic circular navigation button with hover animation.
class _GalleryNavButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _GalleryNavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<_GalleryNavButton> createState() => _GalleryNavButtonState();
}

class _GalleryNavButtonState extends State<_GalleryNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = AppScale.isMobile ? 44.0 : 50.0;
    final double iconSize = AppScale.isMobile ? 20.0 : 22.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? AppColors.surfaceDark.withValues(alpha: 0.95)
                : AppColors.surfaceDark.withValues(alpha: 0.6),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent
                  : AppColors.border.withValues(alpha: 0.8),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: AppColors.accent.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              onTap: widget.onPressed,
              child: Center(
                child: Icon(
                  widget.icon,
                  size: iconSize,
                  color: _isHovered ? AppColors.accent : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

