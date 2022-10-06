import 'package:fiume/models/error.dart';
import 'package:fiume/models/pattern.dart';

class Differentiator {
  final String key;
  final bool headerLeadingEnabled;
  final String? headerLeadingType;
  final String? headerLeadingContent;
  final String? headerTitle;
  final bool headerTrailingEnabled;
  final String? headerTrailingType;
  final String? headerTrailingContent;
  final String selectorType;
  final String selectorShape;

  Differentiator({
    required this.key,
    required this.headerLeadingEnabled,
    this.headerLeadingType,
    this.headerLeadingContent,
    this.headerTitle,
    required this.headerTrailingEnabled,
    this.headerTrailingType,
    this.headerTrailingContent,
    required this.selectorType,
    required this.selectorShape,
  });

  factory Differentiator.fromJSON(Map<String, dynamic> json) {
    return Differentiator(
      key: json['key'],
      headerLeadingEnabled: json['header_leading_enabled'],
      headerLeadingType: json['header_leading_type'],
      headerLeadingContent: json['header_leading_content'],
      headerTitle: json['header_title'],
      headerTrailingEnabled: json['header_trailing_enabled'],
      headerTrailingType: json['header_trailing_type'],
      headerTrailingContent: json['header_trailing_content'],
      selectorType: json['selector_type'],
      selectorShape: json['selector_shape'],
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final int minPurchasable;
  final int maxPurchasable;
  final bool purchasable;
  final bool quarantined;
  final bool banned;
  final List<Differentiator> differentiator;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.minPurchasable,
    required this.maxPurchasable,
    required this.purchasable,
    required this.quarantined,
    required this.banned,
    required this.differentiator,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      minPurchasable: json['min_purchasable'],
      maxPurchasable: json['max_purchasable'],
      purchasable: json['purchasable'],
      quarantined: json['quarantined'],
      banned: json['banned'],
      differentiator: (json['differentiator'] as List).map((e) => Differentiator.fromJSON(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductExtended {
  final Product product;
  final Pattern pattern;
  final int inventoryCount;

  ProductExtended({
    required this.product,
    required this.pattern,
    required this.inventoryCount,
  });

  factory ProductExtended.fromJSON(Map<String, dynamic> json) {
    return ProductExtended(
      product: Product.fromJSON(json['product']),
      pattern: Pattern.fromJSON(json['pattern']),
      inventoryCount: json['inventory_count'],
    );
  }
}

class GetProductsParams {
  final int skip;
  final int limit;

  GetProductsParams({
    required this.skip,
    required this.limit,
  });
}

class GetProductsResponse {
  final bool hasMore;
  final List<ProductExtended> data;

  GetProductsResponse({
    required this.hasMore,
    required this.data
  });

  factory GetProductsResponse.fromJSON(Map<String, dynamic> json) {
    return GetProductsResponse(
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => ProductExtended.fromJSON(e)).toList(),
    );
  }
}

class GetProductsRet {
  final GetProductsResponse? response;
  final ApiErrorV1? error;

  GetProductsRet({
    this.response,
    this.error,
  });
}

class FetchProductParams {
  final String productId;
  final String patternId;

  FetchProductParams({
    required this.productId,
    required this.patternId,
  });
}

class FetchProductRet {
  final ProductExtended? response;
  final ApiErrorV1? error;

  FetchProductRet({
    this.response,
    this.error,
  });
}
