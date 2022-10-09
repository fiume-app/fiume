import 'package:carousel_slider/carousel_slider.dart';
import 'package:fiume/api/products.dart';
import 'package:fiume/models/bag.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/providers/address.dart';
import 'package:fiume/providers/bag.dart';
import 'package:fiume/providers/product.dart';
import 'package:fiume/widgets/address_dialog_v1.dart';
import 'package:fiume/widgets/error_dialog_v1.dart';
import 'package:fiume/widgets/switch_address_dialog_v1.dart';
import 'package:fiume/widgets/switch_pattern_v1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class productFutureParams with _$productFutureParams {
  factory productFutureParams({
    required String productId,
    required String patternId,
  }) = _productFutureParams;
}

class Product extends ConsumerStatefulWidget {
  const Product({
    Key? key,
    required this.productId,
    required this.patternId,
  }) : super(key: key);

  final String productId;
  final String patternId;

  @override
  ConsumerState createState() => _ProductState();
}

class _ProductState extends ConsumerState<Product> {
  int _carouselCurrent = 0;
  int _qty = 1;
  String _addressId = '';
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)));

    return Scaffold(
      appBar: AppBar(),
      body: p.when(
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
                  ref.refresh(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)));
                },
              )
            ],
          ),
        ),
        data: (product) => product == null ? Container() : Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      items: product.product.pattern.images.map((e) =>
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .surface
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.network(
                                    'https://fiume-product-photos.s3.ap-south-1.amazonaws.com/${e
                                        .filename}'),
                              ),
                            ),
                          )).toList(),
                      options: CarouselOptions(
                          viewportFraction: 1,
                          aspectRatio: 1,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _carouselCurrent = index;
                            });
                          }
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.product.pattern.images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                    .withOpacity(_carouselCurrent == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.product.product.name, style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium),
                          Text(product.product.pattern.name, style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                          const Padding(padding: EdgeInsets.all(10)),
                          SwitchPatternV1(
                            productId: product.product.product.id,
                            details: product.product.pattern.details,
                            differentiators: product.product.product.differentiator,
                            cb: (pattern) {
                              ref.read(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)).notifier).setPatternId(pattern.id);
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text('MRP: ₹${product.product.pattern.price}',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge),
                          Text('inclusive of all taxes', style: Theme
                              .of(context)
                              .textTheme
                              .caption),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text('Free delivery'),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              Text('Deliver to: ', style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall),
                              ref
                                  .watch(addressProvider)
                                  .isEmpty ? GestureDetector(
                                child: Text('Add Address', style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.merge(TextStyle(color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)),),
                                onTap: () {
                                  showDialog(context: context,
                                      builder: (
                                          context) => const AddressDialogV1());
                                },
                              ) : Flexible(
                                child: GestureDetector(
                                  child: Text(ref
                                      .watch(addressProvider)
                                      .firstWhere((element) =>
                                  element.id == _addressId, orElse: () => ref
                                      .watch(addressProvider)[0])
                                      .line1, style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.merge(TextStyle(color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary)),
                                    overflow: TextOverflow.ellipsis,),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SwitchAddressDialogV1(
                                          initVal: _addressId,
                                          cb: (val) => setState(() {
                                            _addressId = val;
                                          }),
                                        )
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text('Description', style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge),
                          Text(product.product.product.description, style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                      Text('Qty', style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.merge(TextStyle(color: Theme
                          .of(context)
                          .colorScheme
                          .inversePrimary))),
                      const Padding(padding: EdgeInsets.all(10)),
                      DropdownButton(
                        value: _qty,
                        items: List.generate(product.product.inventoryCount, (index) => index + 1)
                            .map((e) =>
                            DropdownMenuItem(
                              value: e,
                              child: Text(e.toString(), style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.merge(TextStyle(color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary))),
                            )).toList(),
                        onChanged: product.product.bagContains ? null : (v) {
                          setState(() {
                            _qty = int.tryParse(v.toString())!;
                          });
                        },
                        iconEnabledColor: Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary,
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: product.product.bagContains ? () {
                          ref.read(bagProvider.notifier).fetchBagData();
                          context.push("/bag");
                        } : () async {
                          if (ref.watch(addressProvider).isEmpty) {
                            showDialog(context: context, builder: (context) => const ErrorDialogV1(errorString: 'Add Address To Continue'));
                            return;
                          }

                          PostBagRet ret = await postBag(PostBagParams(
                            productId: product.product.product.id,
                            patternId: product.product.pattern.id,
                            addressId: _addressId == '' ? ref.watch(addressProvider)[0].id : _addressId,
                            qty: _qty,
                          ));

                          if (ret.error != null) {
                            showDialog(context: context, builder: (context) => ErrorDialogV1(errorString: ret.error!.msg));
                          }

                          ref.read(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)).notifier).setBagContains(true);
                        },
                        label: product.product.bagContains ? const Text('Go To Bag') : const Text('Add To Bag'),
                        icon: const Icon(Icons.shopping_bag),
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
