import 'package:fiume/api/products.dart';
import 'package:fiume/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsState extends StateNotifier<GetProductsResponse> {
  ProductsState() : super(GetProductsResponse(hasMore: false, data: []));

  setProducts(GetProductsResponse d) {
    state = d;
  }

  addProducts(GetProductsResponse d) {
    state = GetProductsResponse(
      hasMore: d.hasMore,
      data: [
        ...state.data,
        ...d.data,
      ],
    );
  }

  Future<void> loadMoreProducts() async {
    GetProductsRet ret = await getProducts(GetProductsParams(
      skip: state.data.length,
      limit: 10,
    ));

    final error = ret.error;

    if (error != null) {
      throw error;
    }

    state = GetProductsResponse(
      hasMore: ret.response!.hasMore,
      data: [
        ...state.data,
        ...ret.response!.data,
      ],
    );
  }

  ProductExtended getProduct(String productId, String patternId) {
    return state.data.firstWhere((element) => element.product.id == productId && element.pattern.id == patternId);
  }

  Future<ProductExtended> getProductFuture(String productId, String patternId) async {
    //ProductExtended? product = state.data.firstWhere((element) => element.product.id == productId && element.pattern.id == patternId);

    //if (product.runtimeType == Null) {
      try {
        FetchProductRet ret = await fetchProduct(FetchProductParams(
          productId: productId,
          patternId: patternId,
        ));

        return ret.response!;
      } catch (e) {
        rethrow;
      }
    //} else {
    //  return Future.delayed(Duration(milliseconds: 200), () => product);
    //}
  }
}

final productsProvider = StateNotifierProvider<ProductsState, GetProductsResponse>((ref) {
  return ProductsState();
});