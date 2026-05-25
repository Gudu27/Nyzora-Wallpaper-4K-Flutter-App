import 'package:flutter/material.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';

/// Triggers [onLoadMore] when scroll is within [thresholdItems] average rows from end.
class InfiniteScrollListener extends StatelessWidget {
  const InfiniteScrollListener({
    super.key,
    required this.onLoadMore,
    required this.child,
    this.enabled = true,
  });

  final VoidCallback onLoadMore;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!enabled) return false;
        if (notification is! ScrollUpdateNotification) return false;
        if (!notification.metrics.hasPixels) return false;

        final max = notification.metrics.maxScrollExtent;
        final offset = notification.metrics.pixels;
        final threshold = max - (AppConstants.infiniteScrollItemsFromEnd * 280);

        if (offset >= threshold && max > 0) {
          onLoadMore();
        }
        return false;
      },
      child: child,
    );
  }
}
