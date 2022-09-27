import 'package:fiume/models/error.dart';

class Buyer {
  final String id;
  final String name;
  final String email;
  final String? contact;
  final bool quarantined;
  final bool banned;
  final DateTime createdAt;
  final DateTime updatedAt;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    this.contact,
    required this.quarantined,
    required this.banned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Buyer.fromJSON(Map<String, dynamic> json) {
    return Buyer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      contact: json['contact'],
      quarantined: json['quarantined'],
      banned: json['banned'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class GetOrPostBuyersRet {
  final Buyer? response;
  final ApiErrorV1? error;

  GetOrPostBuyersRet({
    this.response,
    this.error,
  });
}
