import 'package:fiume/api/products.dart';
import 'package:fiume/models/bag.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BagState {
  final List<Bag> bag;

  BagState({
    required this.bag,
  });
}

class BagNotifier extends StateNotifier<AsyncValue<BagState>> {
  BagNotifier() : super(AsyncValue.data(BagState(bag: []))) {
    fetchBagData();
  }

  Future<void> fetchBagData() async {
    state = const AsyncValue.loading();

    GetBagRet ret = await getBag();

    if (ret.error != null) {
      state = AsyncValue.error(ret.error!);
      return;
    }

    state = AsyncValue.data(BagState(
      bag: ret.response!,
    ));
  }

  Future<PatchBagRet> incrementQty(String bagId) async {
    PatchBagRet ret = await patchBag(PatchBagParams(bagId: bagId, qtyInc: true));

    if (ret.error == null) {
      state = AsyncValue.data(BagState(
        bag: state.value!.bag.map((e) {
          if (e.id == bagId) {
            return Bag(id: e.id, product: e.product, pattern: e.pattern, inventoryCount: e.inventoryCount, addressId: e.addressId, qty: e.qty + 1, createdAt: e.createdAt, updatedAt: e.updatedAt);
          }

          return e;
        }).toList(),
      ));
    }

    return ret;
  }

  Future<PatchBagRet> decrementQty(String bagId) async {
    PatchBagRet ret = await patchBag(PatchBagParams(bagId: bagId, qtyInc: false));

    if (ret.error == null) {
      state = AsyncValue.data(BagState(
        bag: state.value!.bag.map((e) {
          if (e.id == bagId) {
            return Bag(id: e.id, product: e.product, pattern: e.pattern, inventoryCount: e.inventoryCount, addressId: e.addressId, qty: e.qty - 1, createdAt: e.createdAt, updatedAt: e.updatedAt);
          }

          return e;
        }).toList(),
      ));
    }

    return ret;
  }
  
  Future<DeleteBagRet> deleteItem(String bagId) async {
    DeleteBagRet ret = await deleteBag(DeleteBagParams(bagId: bagId));
    
    if (ret.error == null) {
      List<Bag> bag = state.value!.bag;

      bag.removeWhere((element) => element.id == bagId);

      state = AsyncValue.data(BagState(
        bag: bag,
      ));
    }

    return ret;
  }
}

final bagProvider = StateNotifierProvider<BagNotifier, AsyncValue<BagState>>((ref) {
  return BagNotifier();
});
