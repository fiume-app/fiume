import 'package:fiume/models/error.dart';
import 'package:fiume/models/product.dart';
import 'package:fiume/providers/products.dart';
import 'package:fiume/screens/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductState {
  final ProductExtended product;

  ProductState({
    required this.product,
  });
}

class ProductNotifier extends StateNotifier<AsyncValue<ProductState?>> {
  ProductNotifier(this.ref, this.productId, this.patternId,) : super(const AsyncValue.data(null)) {
    fetchProductData();
  }

  final Ref ref;
  final String productId;
  String patternId;

  Future<void> fetchProductData() async {
    try {
      state = const AsyncValue.loading();

      ProductExtended product = await ref.read(productsProvider.notifier).getProductFuture(productId, patternId);

      state = AsyncValue.data(ProductState(
        product: product,
      ));
    } on GetProductsRet catch (e) {
      state = AsyncValue.error(e);
    } catch (e) {
      state = AsyncValue.error(ApiErrorV1(
        code: 'UNKNOWN_ERROR',
        msg: 'An Unknown Error Occurred',
        error: e.toString(),
      ));
    }
  }

  Future<void> setPatternId(String paId) async {
    try {
      patternId = paId;

      state = const AsyncValue.loading();

      ProductExtended product = await ref.read(productsProvider.notifier).getProductFuture(productId, paId);

      state = AsyncValue.data(ProductState(
        product: product,
      ));
    } on GetProductsRet catch (e) {
      state = AsyncValue.error(e);
    } catch (e) {
      state = AsyncValue.error(ApiErrorV1(
        code: 'UNKNOWN_ERROR',
        msg: 'An Unknown Error Occurred',
        error: e.toString(),
      ));
    }
  }
}

final productProvider = StateNotifierProvider.family<ProductNotifier, AsyncValue<ProductState?>, productFutureParams>((ref, d) {
  return ProductNotifier(
    ref,
    d.productId,
    d.patternId,
  );
});

