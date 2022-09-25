import 'package:fiume/providers/user.dart';
import 'package:fiume/screens/home.dart';
import 'package:fiume/screens/login.dart';
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

    if (user == null) {
      if (state.location == '/login') return null;
      return '/login';
    }

    if (state.location == '/login') return '/';

    return null;
  }

  List<GoRoute> get _routes => [
    GoRoute(
      name: "home",
      path: '/',
      builder: (context, _) => const Home(),
    ),
    GoRoute(
      name: "login",
      path: '/login',
      builder: (context, _) => const Login(),
    ),
  ];
}