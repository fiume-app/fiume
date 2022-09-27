import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiume/models/buyer.dart';
import 'package:fiume/models/error.dart';
import 'package:http/http.dart';

const String _url = 'http://127.0.0.1:3001/v1';

Future<GetOrPostBuyersRet> getOrPostBuyers() async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
    Uri.parse(_url),
    headers: {
      'Authorization': idToken!,
    }
  );

  if (response.statusCode == 200) {
    return GetOrPostBuyersRet(
      response: Buyer.fromJSON(jsonDecode(response.body))
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

  return GetOrPostBuyersRet(
    error: errorObj,
  );
}