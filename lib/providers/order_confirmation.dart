import 'package:fiume/api/products.dart';
import 'package:fiume/models/order.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderConfState {
  final String status;
  final String msg;

  OrderConfState({
    required this.status,
    required this.msg,
  });
}

class OrderConfNotifier extends StateNotifier<OrderConfState> {
  OrderConfNotifier() : super(OrderConfState(
    status: 'loading',
    msg: 'Queueing Order',
  )) {
    placeOrder();
  }

  Future<void> placeOrder() async {
    PostOrderRet ret = await postOrder();

    await Future.delayed(Duration(milliseconds: 750));

    if (ret.error != null) {
      state = OrderConfState(
        status: 'failed',
        msg: 'Failed to Place Order',
      );
      return;
    }

    state = OrderConfState(
      status: 'loading',
      msg: 'Mocking Payment Details',
    );

    await Future.delayed(Duration(milliseconds: 750));

    state = OrderConfState(
      status: 'loading',
      msg: 'Placing Order',
    );

    await Future.delayed(Duration(milliseconds: 750));

    state = OrderConfState(
      status: 'successfull',
      msg: 'Order Placed Successfully',
    );
  }
}

final orderConfProvider = StateNotifierProvider<OrderConfNotifier, OrderConfState>((ref) {
  return OrderConfNotifier();
});
