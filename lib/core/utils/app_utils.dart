import 'package:intl/intl.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';

abstract final class AppUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d').format(date);
  }

  static String formatCount(int? count) {
    if (count == null) return '—';
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  static String resolutionLabel(int? width, int? height) {
    if (width == null || height == null) return 'HD';
    return '$width × $height';
  }

  static String unsplashAttributionUrl(String username) {
    return 'https://unsplash.com/@$username?utm_source=${ApiConstants.appUtmSource}&utm_medium=referral';
  }

  static String sourceLabel(String source) {
    switch (source) {
      case 'unsplash':
        return 'Unsplash';
      case 'wallhaven':
        return 'Wallhaven';
      case 'peapix':
        return 'Peapix';
      default:
        return source;
    }
  }

  static String sourceShort(String source) {
    switch (source) {
      case 'unsplash':
        return 'U';
      case 'wallhaven':
        return 'W';
      case 'peapix':
        return 'P';
      default:
        return '?';
    }
  }

  static Duration animationDuration(
    bool reduceMotion, {
    required Duration normal,
  }) {
    return reduceMotion ? Duration.zero : normal;
  }
}
