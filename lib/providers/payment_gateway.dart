import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentGatewayNotifier extends StateNotifier<bool> {
  PaymentGatewayNotifier() : super(false);

  setVal(bool v) {
    state = v;
  }
}

final paymentGatewayProvider = StateNotifierProvider<PaymentGatewayNotifier, bool>((ref) {
  return PaymentGatewayNotifier();
});
