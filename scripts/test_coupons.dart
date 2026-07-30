
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mobiking/app/services/coupon_service.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  final dioInstance = dio.Dio();

  Get.put(CouponService(dioInstance, box));
  final service = Get.find<CouponService>();

  debugPrint('Fetching coupons...');
  final response = await service.getAllCoupons(page: 1, limit: 100);
  
  if (response.success) {
    debugPrint('Found ${response.data.length} coupons total.');
    for (var coupon in response.data) {
      debugPrint('---');
      debugPrint('Code: ${coupon.code}');
      debugPrint('Valid: ${coupon.isValid}');
      debugPrint('Visible: ${coupon.isVisible}');
      debugPrint('Type: ${coupon.type}');
      debugPrint('Usage Limit: ${coupon.usageLimit}');
      debugPrint('Payment Restr: ${coupon.restrictionPaymentMethod}');
      debugPrint('Is First Order Only: ${coupon.isFirstOrderOnly}');
    }
  } else {
    debugPrint('Failed to fetch coupons: ${response.message}');
  }
}
