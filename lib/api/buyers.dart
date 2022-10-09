import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiume/models/address.dart';
import 'package:fiume/models/buyer.dart';
import 'package:fiume/models/error.dart';
import 'package:http/http.dart';

const String _url = 'https://1cbsbupatd.execute-api.ap-south-1.amazonaws.com/dev/v1';

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

Future<PostAddressRet> postAddress(PostAddressParams d) async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await post(
    Uri.parse('$_url/addresses'),
    body: jsonEncode({
      'line1': d.line1,
      'line2': d.line2,
      'city': d.city,
      'state': d.state,
      'pin_code': d.pinCode,
    }),
    headers: {
      'Authorization': idToken!,
      'Content-Type': 'application/json',
    }
  );

  if (response.statusCode == 200) {
    return PostAddressRet(
      response: Address.fromJSON(jsonDecode(response.body))
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

  return PostAddressRet(
    error: errorObj,
  );
}

Future<GetAddressesRet> getAddresses() async {
  var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  final response = await get(
    Uri.parse('$_url/addresses'),
    headers: {
      'Authorization': idToken!,
    }
  );

  if (response.statusCode == 200) {
    Iterable i = jsonDecode(response.body);

    return GetAddressesRet(
      response: i.map((e) => Address.fromJSON(e)).toList(),
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

  return GetAddressesRet(
    error: errorObj,
  );
}
