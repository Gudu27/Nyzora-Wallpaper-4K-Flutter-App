import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glow_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _hasError = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
              _loading = progress < 100;
            });
          },
          onPageStarted: (_) {
            setState(() {
              _loading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            setState(() => _loading = false);
          },
          onWebResourceError: (_) {
            setState(() {
              _hasError = true;
              _loading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark),
      appBar: AppBar(
        title: Text(widget.title, style: AppTextStyles.appBarTitleMedium(isDark)),
      ),
      body: _hasError
          ? _buildError(isDark)
          : Column(
              children: [
                if (_loading)
                  LinearProgressIndicator(
                    value: _progress > 0 ? _progress : null,
                    color: AppColors.accentPrimary,
                    backgroundColor: AppColors.surfaceVariant(isDark),
                  ),
                Expanded(child: WebViewWidget(controller: _controller)),
              ],
            ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textSecondaryDark),
            const SizedBox(height: 16),
            Text(
              'Failed to load page',
              style: AppTextStyles.emptyTitle(isDark),
            ),
            const SizedBox(height: 24),
            GlowButton(
              label: 'Retry',
              onTap: () {
                setState(() {
                  _hasError = false;
                  _loading = true;
                });
                _controller.loadRequest(Uri.parse(widget.url));
              },
            ),
          ],
        ),
      ),
    );
  }
}
