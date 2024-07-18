import 'package:fiume/models/error.dart';
import 'package:fiume/models/product.dart';
import 'package:fiume/models/pattern.dart';

class GatewayDetails {
  final String? paymentId;
  final String? orderId;

  GatewayDetails({
    this.paymentId,
    this.orderId
  });

  factory GatewayDetails.fromJSON(Map<String, dynamic> json) {
    return GatewayDetails(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
    );
  }
}

class Inventory {
  final String id;
  final String productId;
  final String patternId;
  final String status;
  final String? orderId;
  final bool purchasable;
  final Product product;
  final Pattern pattern;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inventory({
    required this.id,
    required this.productId,
    required this.patternId,
    required this.status,
    this.orderId,
    required this.purchasable,
    required this.product,
    required this.pattern,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inventory.fromJSON(Map<String, dynamic> json) {
    return Inventory(
      id: json['_id'],
      productId: json['product_id'],
      patternId: json['pattern_id'],
      status: json['status'],
      orderId: json['order_id'],
      purchasable: json['purchasable'],
      product: Product.fromJSON(json['product']),
      pattern: Pattern.fromJSON(json['pattern']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Order {
  final String id;
  final String buyerId;
  final String status;
  final String paymentGateway;
  final String paymentStatus;
  final GatewayDetails gatewayDetails;
  final List<Inventory> inventory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.buyerId,
    required this.status,
    required this.paymentGateway,
    required this.paymentStatus,
    required this.gatewayDetails,
    required this.inventory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJSON(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      buyerId: json['buyer_id'],
      status: json['status'],
      paymentGateway: json['payment_gateway'],
      paymentStatus: json['payment_status'],
      gatewayDetails: GatewayDetails.fromJSON(json['gateway_details']),
      inventory: (json['inventory'] as List).map((e) => Inventory.fromJSON(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PostOrderParams {
  final bool pg;

  PostOrderParams({
    required this.pg,
  });
}

class PostOrderRet {
  final Order? response;
  final ApiErrorV1? error;

  PostOrderRet({
    this.response,
    this.error
  });
}

class GetOrdersParams {
  final int skip;
  final int limit;

  GetOrdersParams({
    required this.skip,
    required this.limit,
  });
}

class GetOrdersResponse {
  final bool hasMore;
  final List<Order> data;

  GetOrdersResponse({
    required this.hasMore,
    required this.data,
  });

  factory GetOrdersResponse.fromJSON(Map<String, dynamic> json) {
    return GetOrdersResponse(
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => Order.fromJSON(e)).toList(),
    );
  }
}

class GetOrdersRet {
  final GetOrdersResponse? response;
  final ApiErrorV1? error;

  GetOrdersRet({
    this.response,
    this.error,
  });
}
