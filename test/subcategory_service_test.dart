import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobiking/app/services/sub_category_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'subcategory_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('SubCategoryService', () {
    late SubCategoryService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = SubCategoryService(client: mockClient);
    });

    test('fetchSubCategories returns list of subcategories', () async {
      final dummyData = [
        {
          "_id": "sub1",
          "name": "Mobiles",
          "slug": "mobiles",
          "sequenceNo": 1,
          "upperBanner": "banner1.jpg",
          "lowerBanner": "banner2.jpg",
          "active": true,
          "featured": true,
          "deliveryCharge": 20,
          "minOrderAmount": 100,
          "minFreeDeliveryOrderAmount": 500,
          "photos": ["photo1.jpg"],
          "parentCategory": "cat1",
          "products": ["prod1"],
        },
      ];

      when(mockClient.get(Uri.parse('https://boxbudy.com/api/v1/categories/subCategories'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'data': dummyData}),
          200,
        ),
      );

      final result = await service.fetchSubCategories();

      expect(result.length, 1);
      expect(result[0].name, 'Mobiles');
    });
  });
}
