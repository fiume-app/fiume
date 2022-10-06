import 'package:carousel_slider/carousel_slider.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/models/product.dart';
import 'package:fiume/providers/address.dart';
import 'package:fiume/providers/cart_meta_data.dart';
import 'package:fiume/providers/product.dart';
import 'package:fiume/providers/products.dart';
import 'package:fiume/widgets/address_dialog_v1.dart';
import 'package:fiume/widgets/switch_address_dialog_v1.dart';
import 'package:fiume/widgets/switch_pattern_v1.dart';
import 'package:flutter/material.dart';
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

/* final productFutureProvider = FutureProvider.family<ProductExtended, productFutureParams>((ref, p) async {
  try {
    ProductExtended product = ref.read(productsProvider.notifier).getProduct(p.productId, p.patternId);

    return product;
  } on GetProductsRet catch (e) {
    rethrow;
  } catch (e) {
    throw ApiErrorV1(
      code: 'UNKNOWN_ERROR',
      msg: 'An Unknown Error Occurred',
      error: e.toString(),
    );
  }
}); */

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
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId))).when(
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
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      items: product.product.pattern.images.map((e) =>
                          Padding(
                            padding: EdgeInsets.all(0),
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
                                    'http://127.0.0.1:3003/v1/public/${e
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
                    Padding(padding: EdgeInsets.all(5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.product.pattern.images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.product.product.name ?? '', style: Theme
                              .of(context)
                              .textTheme
                              .headlineMedium),
                          Text(product.product.pattern.name ?? '', style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                          Padding(padding: EdgeInsets.all(10)),
                          SwitchPatternV1(
                            productId: product.product.product.id,
                            details: product.product.pattern.details,
                            differentiators: product.product.product.differentiator,
                            cb: (pattern) {
                              ref.read(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)).notifier).setPatternId(pattern.id);
                            },
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text('MRP: ₹${product.product.pattern.price}',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge),
                          Text('inclusive of all taxes', style: Theme
                              .of(context)
                              .textTheme
                              .caption),
                          Padding(padding: EdgeInsets.all(10)),
                          Text('Free delivery'),
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
                          Padding(padding: EdgeInsets.all(10)),
                          Text('Description', style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge),
                          Text(product.product.product.description ?? '', style: Theme
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
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
                      Padding(padding: EdgeInsets.all(10)),
                      DropdownButton(
                        value: _qty,
                        items: List.generate(5, (index) => index + 1)
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
                        onChanged: (v) {
                          setState(() {
                            _qty = v!;
                          });
                        },
                        iconEnabledColor: Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary,
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: Text('Add To Bag'),
                        icon: Icon(Icons.shopping_bag),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /* body: ref.listen(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)), (previous, next) {
        next.when(
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
              Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        // carouselController: _controller,
                        items: product.product.pattern.images.map((e) =>
                            Padding(
                              padding: EdgeInsets.all(0),
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
                                      'http://127.0.0.1:3003/v1/public/${e
                                          .filename}'),
                                ),
                              ),
                            )).toList(),
                        options: CarouselOptions(
                            viewportFraction: 1,
                            aspectRatio: 1,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              // ref.read(productProvider).setCarouselCurrent(index);
                            }
                        ),
                      ),
                      /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: product.pattern.images.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                              .withOpacity(ref.watch(productProvider).carouselCurrent == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),*/
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.product.product.name ?? '', style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium),
                            Text(product.product.pattern.name ?? '', style: Theme
                                .of(context)
                                .textTheme
                                .labelMedium),
                            Padding(padding: EdgeInsets.all(10)),
                            SwitchPatternV1(
                              productId: product.product.product.id,
                              details: product.product.pattern.details,
                              differentiators: product.product.product.differentiator,
                              cb: (pattern) {
                                ref.refresh(productProvider(productFutureParams(productId: widget.productId, patternId: widget.patternId)));
                              },
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Text('MRP: ₹${product.product.pattern.price}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge),
                            Text('inclusive of all taxes', style: Theme
                                .of(context)
                                .textTheme
                                .caption),
                            Padding(padding: EdgeInsets.all(10)),
                            Text('Free delivery'),
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
                                    element.id ==
                                        ref.watch(cartMetaDataProvider).selectedAddressId)
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
                                      showDialog(context: context,
                                          builder: (
                                              context) => const SwitchAddressDialogV1());
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Text('Description', style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge),
                            Text(product.product.product.description ?? '', style: Theme
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
                    padding: EdgeInsets.symmetric(horizontal: 30),
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
                        Padding(padding: EdgeInsets.all(10)),
                        DropdownButton(
                          value: 1,
                          items: List.generate(5, (index) => index + 1)
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
                          onChanged: (v) {

                          },
                          iconEnabledColor: Theme
                              .of(context)
                              .colorScheme
                              .inversePrimary,
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: Text('Add To Bag'),
                          icon: Icon(Icons.shopping_bag),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }) */
    );
  }
}
