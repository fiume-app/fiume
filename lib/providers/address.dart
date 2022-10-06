import 'package:fiume/api/buyers.dart';
import 'package:fiume/models/address.dart';
import 'package:fiume/providers/cart_meta_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressState extends StateNotifier<List<Address>> {
  AddressState(this._ref) : super([]);

  final Ref _ref;

  setAddresses(List<Address> d) {
    state = d;
  }

  Future<void> addAddress(PostAddressParams d) async {
    PostAddressRet ret = await postAddress(d);

    final error = ret.error;

    if (error != null) {
      throw error;
    }

    state = [
      ...state,
      ret.response!,
    ];
  }

  Future<void> fetchAddresses() async {
    GetAddressesRet ret = await getAddresses();

    final error = ret.error;

    if (error != null) {
      throw error;
    }

    state = [
      ...state,
      ...ret.response!,
    ];
  }
}

final addressProvider = StateNotifierProvider<AddressState, List<Address>>((ref) {
  return AddressState(ref);
});
