import 'package:fiume/api/products.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/models/pattern.dart';
import 'package:fiume/models/product.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final patternsFutureProvider = FutureProvider.family<List<PatternAlt>, String>((ref, productId) async {
  GetPatternsRet ret = await getPatterns(GetPatternsParams(
    productId: productId,
  ));

  final error = ret.error;

  if (error != null) {
    throw error;
  }

  return ret.response!;
});

class SwitchPatternV1 extends ConsumerStatefulWidget {
  const SwitchPatternV1({
    Key? key,
    required this.productId,
    required this.details,
    required this.differentiators,
    required this.cb,
  }) : super(key: key);

  final String productId;
  final List<KeyValStruct> details;
  final List<Differentiator> differentiators;
  final void Function(PatternAlt) cb;

  @override
  ConsumerState createState() => _SwitchPatternV1State();
}

class _SwitchPatternV1State extends ConsumerState<SwitchPatternV1> {
  List<dynamic> selection = [];

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PatternAlt>> resp = ref.watch(patternsFutureProvider(widget.productId));

    return resp.unwrapPrevious().when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
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
                  ref.refresh(patternsFutureProvider(widget.productId));
                },
              )
            ],
          ),
        ),
        data: (resp) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.differentiators.map((e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.headerTitle ?? e.key, style: Theme.of(context).textTheme.titleLarge),
                const Padding(padding: EdgeInsets.all(2)),
                e.selectorType == 'image' ?
                Container(
                  height: 140,
                  child: Builder(
                    builder: (context) {
                      List<PatternAlt> l = [];

                      resp.forEach((i) {
                        bool insert = true;

                        l.forEach((j) {
                          if (i.details.firstWhere((element) => element.key == e.key).value == j.details.firstWhere((element) => element.key == e.key).value) {
                            insert = false;
                          }
                        });

                        if (insert) {
                          l.add(i);
                        }
                      });

                      int index = l.indexWhere((element) {
                        return widget.details.firstWhere((v) => v.key == e.key).value == element.details.firstWhere((v) => v.key == e.key).value;
                      });

                      PatternAlt temp = l[index];

                      l[index] = l[0];
                      l[0] = temp;

                      if (selection.isEmpty) {
                        selection = List.generate(widget.differentiators.length, (index) => null);
                      }
                      selection[widget.differentiators.indexWhere((d) => d.key == e.key)] = l[0].details.firstWhere((v) => v.key == e.key).value;

                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: l.map((i) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  setState(() {
                                    selection[widget.differentiators.indexWhere((d) => d.key == e.key)] = i.details.firstWhere((element) => element.key == e.key).value;
                                  });

                                  resp.forEach((pattern) {
                                    bool match = false;

                                    for (int i = 0; i < widget.differentiators.length; i++) {
                                      if (!match && i != 0) {
                                        break;
                                      }

                                      match = pattern.details[i].value == selection[i] ;
                                    }

                                    if (match) {
                                      widget.cb(pattern);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selection[widget.differentiators.indexWhere((d) => d.key == e.key)] == i.details.firstWhere((element) => element.key == e.key).value ? Theme.of(context).colorScheme.primary : Colors.grey.shade500,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.network('http://127.0.0.1:3003/v1/public/${i.images[0].sizes.small.filename}'),
                                    ),
                                  ),
                                ),
                              ),
                              Text(i.details.firstWhere((element) => element.key == e.key).value),
                            ],
                          ),
                        )).toList(),
                      );
                    },
                  ),
                )
                    :
                Container(
                  height: 60,
                  child: Builder(
                    builder: (context) {
                      List<PatternAlt> l = [];

                      resp.forEach((i) {
                        bool insert = true;

                        l.forEach((j) {
                          if (i.details.firstWhere((element) => element.key == e.key).value == j.details.firstWhere((element) => element.key == e.key).value) {
                            insert = false;
                          }
                        });

                        if (insert) {
                          l.add(i);
                        }
                      });

                      int index = l.indexWhere((element) {
                        return widget.details.firstWhere((v) => v.key == e.key).value == element.details.firstWhere((v) => v.key == e.key).value;
                      });

                      PatternAlt temp = l[index];

                      l[index] = l[0];
                      l[0] = temp;

                      if (selection.isEmpty) {
                        selection = List.generate(widget.differentiators.length, (index) => null);
                      }
                      selection[widget.differentiators.indexWhere((d) => d.key == e.key)] = l[0].details.firstWhere((v) => v.key == e.key).value;

                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: l.map((i) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                selection[widget.differentiators.indexWhere((d) => d.key == e.key)] = i.details.firstWhere((element) => element.key == e.key).value;
                              });

                              resp.forEach((pattern) {
                                bool match = false;

                                for (int i = 0; i < widget.differentiators.length; i++) {
                                  if (!match && i != 0) {
                                    break;
                                  }

                                  match = pattern.details[i].value == selection[i] ;
                                }

                                if (match) {
                                  widget.cb(pattern);
                                }
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selection[widget.differentiators.indexWhere((d) => d.key == e.key)] == i.details.firstWhere((element) => element.key == e.key).value ? Theme.of(context).colorScheme.primary : Colors.grey.shade500,
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(i.details.firstWhere((element) => element.key == e.key).value),
                                ),
                              ),
                            ),
                          ),
                        )).toList(),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(2)),
              ],
            )).toList(),
          );
        }
    );
  }
}
