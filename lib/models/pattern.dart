import 'package:fiume/models/error.dart';

class KeyValStruct {
  final String key;
  final String value;

  KeyValStruct({
    required this.key,
    required this.value,
  });

  factory KeyValStruct.fromJSON(Map<String, dynamic> json) {
    return KeyValStruct(
      key: json['key'],
      value: json['value'],
    );
  }
}

class PatternImageShared {
  final String filename;
  final String mimeType;
  final num fileSize;
  final num width;
  final num height;

  PatternImageShared({
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.width,
    required this.height,
  });

  factory PatternImageShared.fromJSON(Map<String, dynamic> json) {
    return PatternImageShared(
      filename: json['filename'],
      mimeType: json['mimeType'],
      fileSize: json['filesize'],
      width: json['width'],
      height: json['height'],
    );
  }
}

class PatternImageSizes {
  final PatternImageShared small;
  final PatternImageShared? medium;
  final PatternImageShared? large;
  final PatternImageShared? xlarge;

  PatternImageSizes({
    required this.small,
    this.medium,
    this.large,
    this.xlarge,
  });

  factory PatternImageSizes.fromJSON(Map<String, dynamic> json) {
    return PatternImageSizes(
      small: PatternImageShared.fromJSON(json['small']),
      medium: json['medium'] != null ? PatternImageShared.fromJSON(json['medium']) : null,
      large: json['large'] != null ? PatternImageShared.fromJSON(json['large']) : null,
      xlarge: json['xlarge'] != null ? PatternImageShared.fromJSON(json['xlarge']) : null,
    );
  }
}

class PatternImage {
  final String id;
  final String filename;
  final String mimeType;
  final num fileSize;
  final num width;
  final num height;
  final PatternImageSizes sizes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatternImage({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.width,
    required this.height,
    required this.sizes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatternImage.fromJSON(Map<String, dynamic> json) {
    return PatternImage(
      id: json['_id'],
      filename: json['filename'],
      mimeType: json['mimeType'],
      fileSize: json['filesize'],
      width: json['width'],
      height: json['height'],
      sizes: PatternImageSizes.fromJSON(json['sizes']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Pattern {
  final String id;
  final String productId;
  final String name;
  final int minPurchasable;
  final int maxPurchasable;
  final double price;
  final bool purchasable;
  final bool quarantined;
  final bool banned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KeyValStruct> details;
  final List<PatternImage> images;

  Pattern({
    required this.id,
    required this.productId,
    required this.name,
    required this.minPurchasable,
    required this.maxPurchasable,
    required this.price,
    required this.purchasable,
    required this.quarantined,
    required this.banned,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.images,
  });

  factory Pattern.fromJSON(Map<String, dynamic> json) {
    return Pattern(
      id: json['_id'],
      productId: json['product_id'],
      name: json['name'],
      minPurchasable: json['min_purchasable'],
      maxPurchasable: json['max_purchasable'],
      price: json['price'].runtimeType == double ? json['price'] : (json['price'] as int).toDouble(),
      purchasable: json['purchasable'],
      quarantined: json['quarantined'],
      banned: json['banned'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      details: (json['details'] as List).map((e) => KeyValStruct.fromJSON(e)).toList(),
      images: (json['images'] as List).map((e) => PatternImage.fromJSON(e)).toList(),
    );
  }
}

class PatternAlt{
  final String id;
  final String productId;
  final String name;
  final int minPurchasable;
  final int maxPurchasable;
  final double price;
  final bool purchasable;
  final bool quarantined;
  final bool banned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KeyValStruct> details;
  final List<PatternImage> images;
  final int inventoryCount;

  PatternAlt({
    required this.id,
    required this.productId,
    required this.name,
    required this.minPurchasable,
    required this.maxPurchasable,
    required this.price,
    required this.purchasable,
    required this.quarantined,
    required this.banned,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
    required this.images,
    required this.inventoryCount,
  });

  factory PatternAlt.fromJSON(Map<String, dynamic> json) {
    return PatternAlt(
      id: json['_id'],
      productId: json['product_id'],
      name: json['name'],
      minPurchasable: json['min_purchasable'],
      maxPurchasable: json['max_purchasable'],
      price: json['price'].runtimeType == double ? json['price'] : (json['price'] as int).toDouble(),
      purchasable: json['purchasable'],
      quarantined: json['quarantined'],
      banned: json['banned'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      details: (json['details'] as List).map((e) => KeyValStruct.fromJSON(e)).toList(),
      images: (json['images'] as List).map((e) => PatternImage.fromJSON(e)).toList(),
      inventoryCount: json['inventory_count'] ?? 0,
    );
  }
}

class GetPatternsParams {
  final String productId;

  GetPatternsParams({
    required this.productId,
  });
}

class GetPatternsRet {
  final List<PatternAlt>? response;
  final ApiErrorV1? error;

  GetPatternsRet({
    this.response,
    this.error,
  });
}
