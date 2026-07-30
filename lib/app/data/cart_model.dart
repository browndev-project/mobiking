class CartModel {
  final String productId;
  final String variantName; // You might want to add this too for completeness
  final int quantity;
  final double price;
  // You could also add other fields if you need to display them directly from the cart item
  // e.g., final String productName;
  // final String? imageUrl;

  CartModel({
    required this.productId,
    required this.variantName, // Add to constructor
    this.quantity = 1,
    required this.price,
    // this.productName,
    // this.imageUrl,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawProductId = json['productId'];
    String parsedProductId = '';
    if (rawProductId is Map) {
      parsedProductId = rawProductId['_id'] as String? ?? '';
    } else if (rawProductId is String) {
      parsedProductId = rawProductId;
    }
    return CartModel(
      productId: parsedProductId,
      variantName: json['variantName'] as String? ?? '', // Add variantName parsing
      quantity: json['quantity'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId':
          productId, // This would send just the ID back to backend if needed
      'variantName': variantName,
      'quantity': quantity,
      'price': price,
    };
  }
}
