import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/app_update_helper.dart';
import 'package:wallie_4k_wallpapers/core/widgets/app_snackbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final theme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark),
      appBar: AppBar(
        title: Text('SETTINGS', style: AppTextStyles.appBarTitleMedium(isDark)),
      ),
      body: ListView(
        children: [
          _SectionHeader('Appearance'),
          _SettingTile(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            trailing: Switch(
              value: theme.isDark,
              onChanged: (v) => ref.read(themeProvider.notifier).setDarkMode(v),
            ),
          ),
          _SettingTile(
            icon: Icons.contrast,
            label: 'AMOLED Mode',
            trailing: Switch(
              value: theme.amoled,
              onChanged: (v) => ref.read(themeProvider.notifier).setAmoledMode(v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Download Quality', style: AppTextStyles.settingLabel(isDark)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<int>(
              segments: List.generate(
                AppConstants.downloadQualityOptions.length,
                (i) => ButtonSegment(
                  value: i,
                  label: Text(
                    AppConstants.downloadQualityOptions[i],
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
              selected: {theme.downloadQualityIndex},
              onSelectionChanged: (s) {
                ref.read(themeProvider.notifier).setDownloadQuality(s.first);
              },
            ),
          ),
          _SectionHeader('Downloads'),
          _SettingTile(
            icon: Icons.folder_outlined,
            label: 'Save Location',
            trailing: Text(
              'Pictures/${AppConstants.downloadFolderName}/',
              style: AppTextStyles.settingValue(isDark),
            ),
          ),
          _SettingTile(
            icon: Icons.cleaning_services_outlined,
            label: 'Clear Cache',
            onTap: () async {
              await CachedNetworkImage.evictFromCache('');
              imageCache.clear();
              imageCache.clearLiveImages();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared')),
                );
              }
            },
          ),
          _SectionHeader('App'),
          _SettingTile(
            icon: Icons.system_update_outlined,
            label: 'Check for Updates',
            onTap: () async {
              await AppUpdateHelper.checkForUpdate();
              if (context.mounted) {
                AppSnackbar.info(context, 'Update check completed');
              }
            },
          ),
          _SectionHeader('About'),
          _SettingTile(
            icon: Icons.info_outline,
            label: 'App Version',
            trailing: Text('1.0.0 (Build 1)', style: AppTextStyles.settingValue(isDark)),
          ),
          _SettingTile(
            icon: Icons.star_outline,
            label: 'Rate the App',
            onTap: () => launchUrl(
              Uri.parse(AppConstants.playStoreUrl),
              mode: LaunchMode.externalApplication,
            ),
          ),
          _SettingTile(
            icon: Icons.share_outlined,
            label: 'Share App',
            onTap: () => Share.share(
              '${AppConstants.appName} — ${AppConstants.appTagline}\n${AppConstants.playStoreUrl}',
            ),
          ),
          _SettingTile(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () => context.pushNamed(
              AppRoutes.webview,
              extra: {
                'title': 'Privacy Policy',
                'url': AppConstants.privacyPolicyUrl,
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.settingsSectionHeader(true),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariantDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimaryDark),
      ),
      title: Text(label, style: AppTextStyles.settingLabel(true)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
