import 'package:fiume/providers/address.dart';
import 'package:fiume/providers/cart_meta_data.dart';
import 'package:fiume/providers/user.dart';
import 'package:fiume/screens/home.dart';
import 'package:fiume/screens/login.dart';
import 'package:fiume/screens/product.dart';
import 'package:fiume/screens/profile.dart';
import 'package:fiume/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = AsyncRouterNotifier(ref);

  return GoRouter(
    debugLogDiagnostics: true, // For demo purposes
    refreshListenable: router, // This notifiies `GoRouter` for refresh events
    redirect: router._redirect, // All the logic is centralized here
    routes: router._routes, // All the routes can be found there
  );
});

class AsyncRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AsyncRouterNotifier(this._ref) {
    _ref.listen(userProvider, (_, __) {
      notifyListeners();
    });
  }

  Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final user = _ref.read(userProvider);

    if (user?.user == null) {
      if (state.location.startsWith('/login')) return null;
      return '/login';
    }

    if (state.location.startsWith('/login')) {
      return '/';
    }

    if (user?.apiUser == null) {
      _ref.read(userProvider.notifier).getApiUser();
      _ref.read(addressProvider.notifier).fetchAddresses();

      return null;
    }

    return null;
  }

  List<ShellRoute> get _routes => [
    ShellRoute(
      builder: (context, state, child) {
        return child;
      },
      routes: [
        GoRoute(
          name: "home",
          path: '/',
          builder: (context, _) => const Home(),
          routes: [
            GoRoute(
              name: "profile",
              path: "profile",
              builder: (context, _) => const Profile(),
            ),
            GoRoute(
              name: "product",
              path: "product/:product_id/:pattern_id",
              builder: (context, state) {
                return Product(productId: state.params['product_id'] ?? '', patternId: state.params['pattern_id'] ?? '');
              }
            ),
          ],
        ),
        GoRoute(
          name: "login",
          path: '/login',
          builder: (context, _) => const Login(),
          routes: [
            GoRoute(
              name: "signup",
              path: 'signup',
              builder: (context, _) => const Signup(),
            ),
          ],
        ),
      ],
    ),
  ];
}