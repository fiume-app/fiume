import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiume/models/bag.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/models/order.dart';
import 'package:fiume/models/pattern.dart';
import 'package:fiume/models/product.dart';
import 'package:http/http.dart';

const String _url = 'https://2n9naz5qpi.execute-api.ap-south-1.amazonaws.com/dev/v1';

Future<GetProductsRet> getProducts(GetProductsParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url?skip=${d.skip}&limit=${d.limit}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetProductsRet(
      response: GetProductsResponse.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetProductsRet(
    error: errorObj,
  );
}

Future<GetPatternsRet> getPatterns(GetPatternsParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/${d.productId}/patterns'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    Iterable i = jsonDecode(response.body);

    return GetPatternsRet(
      response: i.map((e) => PatternAlt.fromJSON(e)).toList(),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetPatternsRet(
    error: errorObj,
  );
}

Future<FetchProductRet> fetchProduct(FetchProductParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/${d.productId}/patterns/${d.patternId}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return FetchProductRet(
      response: ProductExtended.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return FetchProductRet(
    error: errorObj,
  );
}

Future<PostBagRet> postBag(PostBagParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
    Uri.parse('$_url/bags'),
    body: jsonEncode({
      'product_id': d.productId,
      'pattern_id': d.patternId,
      'address_id': d.addressId,
      'qty': d.qty,
    }),
    headers: {
      'Authorization': idToken!,
      'Content-Type': 'application/json',
    }
  );

  if (response.statusCode == 200) {
    return PostBagRet(
      response: response.statusCode,
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return PostBagRet(
    error: errorObj,
  );
}

Future<GetBagRet> getBag() async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/bags'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    Iterable i = jsonDecode(response.body);

    return GetBagRet(
      response: i.map((e) => Bag.fromJSON(e)).toList(),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetBagRet(
    error: errorObj,
  );
}

Future<DeleteBagRet> deleteBag(DeleteBagParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await delete(
    Uri.parse('$_url/bags/${d.bagId}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return DeleteBagRet(
      response: response.statusCode,
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return DeleteBagRet(
    error: errorObj,
  );
}

Future<PatchBagRet> patchBag(PatchBagParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await patch(
    Uri.parse('$_url/bags/${d.bagId}?qty=${d.qtyInc ? 'increment' : 'decrement'}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return PatchBagRet(
      response: response.statusCode,
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return PatchBagRet(
    error: errorObj,
  );
}

Future<PostOrderRet> postOrder(PostOrderParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  
  final response = await post(
    Uri.parse('$_url/orders'),
    body: jsonEncode({
      'pg': d.pg,
    }),
    headers: {
      'Authorization': idToken!,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);

    return PostOrderRet(
      response: Order(
        id: json['_id'],
        buyerId: json['buyer_id'],
        status: json['status'],
        paymentGateway: json['payment_gateway'],
        paymentStatus: json['payment_status'],
        gatewayDetails: GatewayDetails.fromJSON(json['gateway_details']),
        inventory: [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      ),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return PostOrderRet(
    error: errorObj,
  );
}

Future<GetOrdersRet> getOrders(GetOrdersParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  
  final response = await get(
    Uri.parse('$_url/orders?skip=${d.skip}&limit=${d.limit}'),
    headers: {
      'Authorization': idToken!,
    },
  );

  if (response.statusCode == 200) {
    return GetOrdersRet(
      response: GetOrdersResponse.fromJSON(jsonDecode(response.body)),
    );
  }

  ApiErrorV1 errorObj;

  try {
    errorObj = ApiErrorV1.fromJSON(jsonDecode(response.body));
  } catch (e) {
    errorObj = ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'Something went wrong !',
      error: '',
    );
  }

  return GetOrdersRet(
    error: errorObj,
  );
} 
