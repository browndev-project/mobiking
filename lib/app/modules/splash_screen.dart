import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiking/app/modules/bottombar/bottom_bar.dart';

import '../controllers/category_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/sub_category_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 🚀 Start pre-fetching all critical data in parallel while splash is showing
    final categoryController = Get.find<CategoryController>();
    final productController = Get.find<ProductController>();
    final subCategoryController = Get.find<SubCategoryController>();
    final homeController = Get.find<HomeController>();

    categoryController.fetchCategories();
    productController.loadProductsOnDemand();
    subCategoryController.loadSubCategories();
    homeController.fetchHomeLayout();

    // Reduced delay for fast, responsive app launch
    await Future.delayed(const Duration(milliseconds: 600));
    
    // ✅ APP STORE COMPLIANCE: Always allow users to enter the app to browse.
    // We only require login for account-based features (Adding to Cart, Checkout).
    Get.off(
      () => MainContainerScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Wrap the body with SafeArea to handle system insets
      body: Center(
        child: Image.asset(
          'assets/animations/splash0001.gif',
          width: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
