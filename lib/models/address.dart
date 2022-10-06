import 'package:fiume/models/error.dart';

class Address {
  final String id;
  final String buyerId;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pinCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.buyerId,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJSON(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      buyerId: json['buyer_id'],
      line1: json['line1'],
      line2: json['line2'],
      city: json['city'],
      state: json['state'],
      pinCode: json['pin_code'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PostAddressParams {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pinCode;

  PostAddressParams({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pinCode,
  });
}

class PostAddressRet {
  final Address? response;
  final ApiErrorV1? error;

  PostAddressRet({
    this.response,
    this.error
  });
}

class GetAddressesRet {
  final List<Address>? response;
  final ApiErrorV1? error;

  GetAddressesRet({
    this.response,
    this.error,
  });
}
