import 'package:fiume/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiume'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              context.push("/profile");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Home'),
          ],
        ),
      ),
    );
  }
}
