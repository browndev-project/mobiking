import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobiking/app/services/order_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('OrderService', () {
    late OrderService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = OrderService(client: mockClient);
      service.setTestToken('dummy_token');
    });

    test('getUserOrders returns a list of orders', () async {
      final dummyOrders = [
        {
          "_id": "order1",
          "orderId": "ORD123",
          "status": "pending",
          "shippingStatus": "pending",
          "paymentStatus": "pending",
          "type": "online",
          "method": "COD",
          "orderAmount": 1000.0,
          "items": [
            {
              "_id": "item1",
              "productId": {"_id": "prod1"},
              "variantName": "Default",
              "quantity": 2,
              "price": 200.0
            },
          ],
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        },
      ];

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'success': true, 'data': dummyOrders}),
          200,
        ),
      );

      final orders = await service.getUserOrders();

      expect(orders.length, 1);
      expect(orders[0].orderId, 'ORD123');
    });
  });
}
