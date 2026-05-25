import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/categories/widgets/category_card.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);
    final categories = CategoryEntity.all;

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      appBar: AppBar(
        title: Text('CATEGORIES', style: AppTextStyles.appBarTitle(isDark)),
        centerTitle: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryCard(
            category: cat,
            index: index,
            onTap: () => context.pushNamed(
              AppRoutes.categoryDetail,
              pathParameters: {'id': cat.id},
              extra: cat,
            ),
          );
        },
      ),
    );
  }
}
