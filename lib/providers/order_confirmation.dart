import 'package:fiume/api/products.dart';
import 'package:fiume/models/order.dart';
import 'package:fiume/providers/payment_gateway.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderConfState {
  final String status;
  final String msg;

  OrderConfState({
    required this.status,
    required this.msg,
  });
}

class OrderConfNotifier extends StateNotifier<OrderConfState> {
  OrderConfNotifier(this._ref) : super(OrderConfState(
    status: 'loading',
    msg: 'Queueing Order',
  )) {
    placeOrder();
  }

  final Ref _ref;

  Future<void> placeOrder() async {
    var _razorpay = Razorpay();

    PostOrderRet ret = await postOrder(PostOrderParams(pg: _ref.watch(paymentGatewayProvider)));

    await Future.delayed(Duration(milliseconds: 750));

    if (ret.error != null) {
      state = OrderConfState(
        status: 'failed',
        msg: 'Failed to Place Order',
      );
      return;
    }

    print(ret.response!.gatewayDetails);

    if (ret.response!.paymentGateway == 'razorpay') {
      var options = {
        'key': 'rzp_test_8BTbGOj8uzLilz',
        'order_id': ret.response!.gatewayDetails.orderId,
        'name': 'Fiume',
      };

      _razorpay.open(options);

      await Future.delayed(Duration(seconds: 2));
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
  return OrderConfNotifier(ref);
});
