import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/models/pattern.dart';
import 'package:fiume/models/product.dart';
import 'package:http/http.dart';

const String _url = 'http://127.0.0.1:3002/v1';

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