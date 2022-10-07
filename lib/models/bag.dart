import 'package:fiume/models/error.dart';
import 'package:fiume/models/pattern.dart';
import 'package:fiume/models/product.dart';

class Bag {
  final String id;
  final Product product;
  final Pattern pattern;
  final int inventoryCount;
  final String addressId;
  final int qty;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bag({
    required this.id,
    required this.product,
    required this.pattern,
    required this.inventoryCount,
    required this.addressId,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bag.fromJSON(Map<String, dynamic> json) {
    return Bag(
      id: json['_id'],
      product: Product.fromJSON(json['product']),
      pattern: Pattern.fromJSON(json['pattern']),
      inventoryCount: json['inventory_count'],
      addressId: json['address_id'],
      qty: json['qty'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PostBagParams {
  final String productId;
  final String patternId;
  final String addressId;
  final int qty;

  PostBagParams({
    required this.productId,
    required this.patternId,
    required this.addressId,
    required this.qty
  });
}

class PostBagRet {
  final int? response;
  final ApiErrorV1? error;

  PostBagRet({
    this.response,
    this.error,
  });
}

class GetBagRet {
  final List<Bag>? response;
  final ApiErrorV1? error;

  GetBagRet({
    this.response,
    this.error,
  });
}

class DeleteBagParams {
  final String bagId;

  DeleteBagParams({
    required this.bagId,
  });
}

class DeleteBagRet {
  final int? response;
  final ApiErrorV1? error;

  DeleteBagRet({
    this.response,
    this.error,
  });
}

class PatchBagParams {
  final String bagId;
  final bool qtyInc;

  PatchBagParams({
    required this.bagId,
    required this.qtyInc,
  });
}

class PatchBagRet {
  final int? response;
  final ApiErrorV1? error;

  PatchBagRet({
    this.response,
    this.error,
  });
}
