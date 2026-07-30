import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobiking/app/services/product_service.dart';

import 'product_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ProductService', () {
    late ProductService productService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      productService = ProductService(client: mockClient);
    });

    test('getAllProducts returns list of ProductModel', () async {
      final mockResponseData = {
        'data': {
          'products': [
            {
              "_id": "1",
              "name": "Phone",
              "active": true,
              "sellingPrice": [
                {"price": 999.99},
              ],
            }
          ]
        }
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponseData), 200),
      );

      final result = await productService.getAllProducts();

      expect(result.length, 1);
      expect(result.first.name, "Phone");
    });
  });
}
