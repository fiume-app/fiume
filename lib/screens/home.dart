import 'package:fiume/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Home'),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text('Sign Out'),
                onPressed: () => ref.read(userProvider.notifier).signout(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
