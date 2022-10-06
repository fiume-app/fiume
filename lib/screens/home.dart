import 'package:fiume/api/products.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/models/product.dart';
import 'package:fiume/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productsFutureProvider = FutureProvider<GetProductsResponse>((ref) async {
  GetProductsRet ret = await getProducts(GetProductsParams(
    skip: 0,
    limit: 10,
  ));

  final error = ret.error;

  if (error != null) {
    throw error;
  }

  ref.read(productsProvider.notifier).setProducts(ret.response!);

  return ret.response!;
});

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GetProductsResponse> resp = ref.watch(productsFutureProvider);

    GetProductsResponse products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              context.push("/profile");
            },
          ),
        ],
      ),
      body: resp.unwrapPrevious().when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text((err as ApiErrorV1).msg, style: Theme.of(context).textTheme.titleMedium),
              Text('ERR_CODE: ${(err).code}', style: Theme.of(context).textTheme.overline),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                child: const Text('Retry'),
                onPressed: () {
                  ref.refresh(productsProvider);
                },
              )
            ],
          ),
        ),
        data: (resp) => RefreshIndicator(
          child: ListView.builder(
            itemCount: products.data.length + 1,
            itemBuilder: (context, index) {
              if (index < products.data.length) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      context.push('/product/${products.data[index].product.id}/${products.data[index].pattern.id}');
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        Container(
                          height: 150,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade100,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network('http://127.0.0.1:3003/v1/public/${products.data[index].pattern.images[0].sizes.small.filename}'),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products.data[index].product.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  products.data[index].pattern.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const Padding(padding: EdgeInsets.all(10)),
                                Text(
                                  '₹${products.data[index].pattern.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                if (products.hasMore) {
                  ref.read(productsProvider.notifier).loadMoreProducts();
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                } else {
                  return Container();
                }
              }
            },
          ),
          onRefresh: () async {
            ref.refresh(productsFutureProvider);
          },
        ),
      ),
    );
  }
}
