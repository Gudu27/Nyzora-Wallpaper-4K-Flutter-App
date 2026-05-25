import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/search_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/search/widgets/recent_searches.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/search/widgets/search_bar_widget.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/search/widgets/trending_tags.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/error_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/staggered_grid.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/utils/infinite_scroll_listener.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      setState(() => _query = value.trim());
      ref.read(searchQueryProvider.notifier).state = value.trim();
    });
  }

  void _submitSearch(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    ref.read(recentSearchesProvider.notifier).addSearch(q);
    setState(() => _query = q);
    ref.read(searchQueryProvider.notifier).state = q;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);
    final filter = ref.watch(searchSourceFilterProvider);
    final resultsAsync = _query.isEmpty
        ? null
        : ref.watch(searchResultsProvider(_query));
    final searchLoadingMore = _query.isEmpty
        ? false
        : ref.watch(searchLoadingMoreProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(
                controller: _controller,
                onChanged: _onSearchChanged,
                onSubmitted: _submitSearch,
              ),
            ),
            if (_query.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Results for '$_query'",
                  style: AppTextStyles.bodySemiBold(isDark),
                ),
              ),
              const SizedBox(height: 8),
              _SourceFilters(
                filter: filter,
                onChanged: (f) {
                  ref.read(searchSourceFilterProvider.notifier).state = f;
                  ref.invalidate(searchResultsProvider(_query));
                },
              ),
            ],
            Expanded(
              child: _query.isEmpty
                  ? ListView(
                      children: [
                        RecentSearches(
                          onTap: (term) {
                            _controller.text = term;
                            _submitSearch(term);
                          },
                        ),
                        TrendingTags(
                          onTagTap: (tag) {
                            _controller.text = tag;
                            _submitSearch(tag);
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    )
                  : resultsAsync!.when(
                      loading: () => GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: 6,
                        itemBuilder: (_, __) => const WallpaperCardShimmer(),
                      ),
                      error: (e, _) => ErrorState(
                        message: e is Failure ? e.message : 'Search failed',
                        onRetry: () =>
                            ref.invalidate(searchResultsProvider(_query)),
                      ),
                      data: (items) {
                        if (items.isEmpty) {
                          return _EmptyResults(
                            query: _query,
                            onTagTap: (tag) {
                              _controller.text = tag;
                              _submitSearch(tag);
                            },
                          );
                        }
                        return InfiniteScrollListener(
                          onLoadMore: () => ref
                              .read(searchResultsProvider(_query).notifier)
                              .loadMore(),
                          child: ListView(
                            children: [
                              WallpaperStaggeredGrid(
                                wallpapers: items,
                                isLoadingMore: searchLoadingMore,
                                onTap: (wp) => context.pushNamed(
                                  AppRoutes.wallpaperDetail,
                                  pathParameters: {'id': wp.id},
                                  extra: wp,
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceFilters extends ConsumerWidget {
  const _SourceFilters({required this.filter, required this.onChanged});

  final SearchSourceFilter filter;
  final ValueChanged<SearchSourceFilter> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    const filters = SearchSourceFilter.values;
    const labels = ['All', 'Unsplash', 'Wallhaven'];

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: List.generate(filters.length, (i) {
          final active = filter == filters[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(filters[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: active ? AppColors.accentGradient1 : null,
                  color: active ? null : AppColors.surfaceVariant(isDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: AppTextStyles.chip(isDark, active: active),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyResults extends ConsumerWidget {
  const _EmptyResults({required this.query, required this.onTagTap});

  final String query;
  final ValueChanged<String> onTagTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/search_empty.json',
            width: 160,
            height: 160,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.search_off, size: 80),
          ),
          Text(
            "No results for '$query'",
            style: AppTextStyles.emptyTitle(isDark),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: ['nature', 'space', 'abstract'].map((tag) {
              return ActionChip(
                label: Text(tag),
                onPressed: () => onTagTap(tag),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
