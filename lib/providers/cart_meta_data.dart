import 'package:fiume/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartMetaData {
  final String productId;
  final String patternId;
  final ProductExtended? product;
  final String selectedAddressId;
  final int qty;

  CartMetaData({
    required this.productId,
    required this.patternId,
    required this.product,
    required this.selectedAddressId,
    required this.qty,
  });
}

class CartMetaDataState extends StateNotifier<CartMetaData> {
  CartMetaDataState() : super(CartMetaData(productId: '', patternId: '', product: null, selectedAddressId: '', qty: 1));

  setProductId(String id) {
    state = CartMetaData(
      productId: id,
      patternId: state.patternId,
      product: state.product,
      selectedAddressId: state.selectedAddressId,
      qty: state.qty,
    );
  }

  setPatternId(String id) {
    state = CartMetaData(
      productId: state.productId,
      patternId: id,
      product: state.product,
      selectedAddressId: state.selectedAddressId,
      qty: state.qty,
    );
  }

  setProduct(ProductExtended product) {
    print(product.pattern.name);

    state = CartMetaData(
      productId: state.productId,
      patternId: state.patternId,
      product: product,
      selectedAddressId: state.selectedAddressId,
      qty: state.qty,
    );
  }

  setAddressId(String id) {
    state = CartMetaData(
      productId: state.productId,
      patternId: state.patternId,
      product: state.product,
      selectedAddressId: id,
      qty: state.qty,
    );
  }

  setQty(int qty) {
    state = CartMetaData(
      productId: state.productId,
      patternId: state.patternId,
      product: state.product,
      selectedAddressId: state.selectedAddressId,
      qty: qty,
    );
  }
}

final cartMetaDataProvider = StateNotifierProvider<CartMetaDataState, CartMetaData>((ref) {
  return CartMetaDataState();
});
