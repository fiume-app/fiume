import 'package:fiume/models/error.dart';
import 'package:fiume/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class Orders extends ConsumerWidget {
  const Orders({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var resp = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
                  ref.refresh(ordersProvider);
                },
              )
            ],
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () async {
            ref.refresh(ordersProvider);
          },
          child: ListView.builder(
            itemCount: state.orderRes.data.length + 1,
            itemBuilder: (context, index) {
              if (index < state.orderRes.data.length) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Divider(),
                      ListTile(
                        title: const Text('Order'),
                        subtitle: Text(state.orderRes.data[index].id),
                      ),
                      Column(
                        children: state.orderRes.data[index].inventory.map((e) {
                          return Row(
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
                                  child: Image.network('https://fiume-product-photos.s3.ap-south-1.amazonaws.com/${e.pattern.images[0].sizes.small.filename}'),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.product.name,
                                        style: Theme.of(context).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        e.pattern.name,
                                        style: Theme.of(context).textTheme.titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const Padding(padding: EdgeInsets.all(10)),
                                      Text(
                                        '₹${e.pattern.price.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.headlineSmall,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      ListTile(
                        title: Text('Status: ${state.orderRes.data[index].status}'),
                        subtitle: Text('Ordered On: ${DateFormat.yMMMEd().format(state.orderRes.data[index].createdAt)}'),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              } else {
                if (state.orderRes.hasMore) {
                  ref.read(ordersProvider.notifier).loadMoreOrders();
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
