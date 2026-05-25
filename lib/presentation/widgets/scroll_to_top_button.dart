import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';

class ScrollToTopButton extends ConsumerStatefulWidget {
  const ScrollToTopButton({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  ConsumerState<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends ConsumerState<ScrollToTopButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final show = widget.scrollController.offset >
        AppConstants.scrollToTopThreshold;
    if (show != _visible) setState(() => _visible = show);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Positioned(
      right: 24,
      bottom: 90,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !_visible,
          child: FloatingActionButton.small(
            backgroundColor: AppColors.accentPrimary,
            tooltip: 'Scroll to top',
            onPressed: () {
              widget.scrollController.animateTo(
                0,
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
