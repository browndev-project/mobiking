
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:mobiking/app/services/coupon_service.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  final dioInstance = dio.Dio();

  Get.put(CouponService(dioInstance, box));
  final service = Get.find<CouponService>();
  
  print('Fetching coupons...');
  final response = await service.getAllCoupons(page: 1, limit: 100);
  
  if (response.success) {
    print('Found ${response.data.length} coupons total.');
    for (var coupon in response.data) {
      print('---');
      print('Code: ${coupon.code}');
      print('Valid: ${coupon.isValid}');
      print('Visible: ${coupon.isVisible}');
      print('Type: ${coupon.type}');
      print('Usage Limit: ${coupon.usageLimit}');
      print('Payment Restr: ${coupon.restrictionPaymentMethod}');
      print('Is First Order Only: ${coupon.isFirstOrderOnly}');
    }
  } else {
    print('Failed to fetch coupons: ${response.message}');
  }
}
