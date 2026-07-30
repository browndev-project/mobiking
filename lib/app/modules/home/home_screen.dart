
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import 'package:mobiking/app/controllers/home_controller.dart';
import '../../controllers/sub_category_controller.dart';
import '../../controllers/tab_controller_getx.dart';
import '../../controllers/product_controller.dart';
import '../../themes/app_theme.dart';

import '../../widgets/search_tab_sliver_app_bar.dart' show SearchTabSliverAppBar;

import 'package:mobiking/app/modules/home/widgets/home_shimmer.dart';
import 'package:mobiking/app/modules/home/widgets/_build_section_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final CategoryController categoryController = Get.find<CategoryController>();
  final SubCategoryController subCategoryController =
      Get.find<SubCategoryController>();
  final TabControllerGetX tabController = Get.find<TabControllerGetX>();
  final ProductController productController = Get.find<ProductController>();
  final HomeController homeController = Get.find<HomeController>();

  late ScrollController _scrollController;
  final RxBool _showScrollToTopButton = false.obs;

  @override
  bool get wantKeepAlive => true; // 🚀 Prevent lag when navigating back

  @override
  void initState() {
    super.initState();
    // 🚀 OPTIMIZATION: Use on-demand loading that respects cache instead of force-refreshing every time
    productController.loadProductsOnDemand();
    categoryController.fetchCategories();
    subCategoryController.loadSubCategories();
    homeController.fetchHomeLayout();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200 && !_showScrollToTopButton.value) {
      _showScrollToTopButton.value = true;
    } else if (_scrollController.offset < 200 && _showScrollToTopButton.value) {
      _showScrollToTopButton.value = false;
    }

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.75) {
      _triggerLoadMore();
    }
  }

  void _triggerLoadMore() {
    if (productController.isFetchingMore.value ||
        !productController.hasMoreProducts.value) {
      return;
    }

    debugPrint("🚀 Infinite scroll triggered from HomeScreen");
    productController.fetchMoreProducts();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> onRefresh() async {
    debugPrint("🔄 Manual refresh triggered from HomeScreen");
    await Future.wait([
      productController.refreshProducts(),
      categoryController.refreshCategories(),
      subCategoryController.refreshSubCategories(),
      homeController.refreshAllData(),
    ]);
    debugPrint("✅ All data refreshed");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Stack(
        children: [
          Obx(() {
            if (homeController.isLoading && homeController.homeData == null) {
              return const HomeShimmer();
            }
            
            final categories = homeController.categories;
            
            // ✅ React to controller changes so TabBarView rebuilds with the new instance
            // (We removed resetWithLength from here because it shouldn't be called during build)
            final _ = tabController.resetCount.value;

            if (categories.isEmpty) {
               return const Center(child: Text("No categories found"));
            }

            return DefaultTabController(
              length: categories.length,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: NestedScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SearchTabSliverAppBar(
                        onSearchChanged: (value) {}, 
                      ),
                    ];
                  },
                  body: TabBarView(
                    key: ValueKey('tab_bar_view_${categories.length}_${tabController.resetCount.value}'),
                    physics: const NeverScrollableScrollPhysics(), // Disables swiping between tabs
                    controller: tabController.controller, // FIXED: Correct property name
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final categoryId = category.id;
                      final groups = homeController.categoryGroups[categoryId] ?? [];
                      final isCategoryLoading = homeController.isCategoryLoading(categoryId);

                      return ProductGridViewSection(
                        key: ValueKey('tab_view_${category.id}'),
                        productController: productController,
                        index: index,
                        groups: groups,
                        bannerImageUrl: category.lowerBanner ?? '',
                        categoryGridItems: subCategoryController.subCategories,
                        subCategories: subCategoryController.subCategories,
                        categoryId: categoryId,
                        isLoading: isCategoryLoading,
                      );
                    }),
                  ),
                ),
              ),
            );
          }),
          // Scroll to top button
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Obx(
              () => AnimatedOpacity(
                opacity: _showScrollToTopButton.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _showScrollToTopButton.value
                    ? FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColors.darkPurple,
                        onPressed: _scrollToTop,
                        child: const Icon(Icons.arrow_upward, color: Colors.white),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
