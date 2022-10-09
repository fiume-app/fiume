import 'package:fiume/models/bag.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/providers/bag.dart';
import 'package:fiume/widgets/error_dialog_v1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bag extends ConsumerWidget {
  const Bag({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var b = ref.watch(bagProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bag'),
      ),
      body: b.when(
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
                  ref.refresh(bagProvider);
                },
              )
            ],
          ),
        ),
        data: (state) => Stack(
          children: [
            state.bag.isEmpty ? const Center(child: Text('! No Items In Bag')) : RefreshIndicator(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: state.bag.map((e) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              e.qty > 1 ?
                              FloatingActionButton(
                                mini: true,
                                elevation: 0,
                                onPressed: () async {
                                  PatchBagRet ret = await ref.read(bagProvider.notifier).decrementQty(e.id);

                                  if (ret.error != null) {
                                    showDialog(context: context, builder: (context) => ErrorDialogV1(errorString: ret.error!.msg));
                                  }
                                },
                                child: const Icon(Icons.remove),
                              )
                                  :
                              FloatingActionButton(
                                mini: true,
                                elevation: 0,
                                onPressed: () async {
                                  DeleteBagRet ret = await ref.read(bagProvider.notifier).deleteItem(e.id);

                                  if (ret.error != null) {
                                    showDialog(context: context, builder: (context) => ErrorDialogV1(errorString: ret.error!.msg));
                                  }
                                },
                                child: const Icon(Icons.close),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(e.qty.toString(), style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Row(
                            children: [
                              FloatingActionButton(
                                mini: true,
                                elevation: 0,
                                onPressed: () async {
                                  PatchBagRet ret = await ref.read(bagProvider.notifier).incrementQty(e.id);

                                  if (ret.error != null) {
                                    showDialog(context: context, builder: (context) => ErrorDialogV1(errorString: ret.error!.msg));
                                  }
                                },
                                child: const Icon(Icons.add),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )).toList(),
              ),
              onRefresh: () async {
                ref.refresh(bagProvider);
              },
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total: ', style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.merge(TextStyle(color: Theme
                          .of(context)
                          .colorScheme
                          .inversePrimary))),
                      Text(
                        '₹${state.bag.isEmpty ? 0 : state.bag.map((e) => e.pattern.price * e.qty).reduce((value, element) => value + element).toStringAsFixed(2)}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.merge(TextStyle(color: Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary))
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: state.bag.isEmpty ? null : () {
                          showDialog(context: context, builder: (c) => AlertDialog(
                            title: const Text('Are you Sure?'),
                            content: const Text('This is an irreversible process !'),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pop(c);
                              }, child: const Text('No')),
                              ElevatedButton(onPressed: () {
                                Navigator.pop(c);
                                context.push("/order_conf");
                              }, child: const Text('Yes')),
                            ],
                          ));
                        },
                        label: const Text('Checkout'),
                        icon: const Icon(Icons.credit_card),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
