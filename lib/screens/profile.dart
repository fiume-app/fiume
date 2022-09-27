import 'package:fiume/providers/user.dart';
import 'package:fiume/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(Icons.account_circle, size: 150)
          ),
          Text(ref.read(userProvider)!.apiUser!.name, style: Theme.of(context).textTheme.headlineMedium),
          Text(ref.read(userProvider)!.apiUser!.email, style: Theme.of(context).textTheme.labelLarge),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('Sign Out'),
              onPressed: () {
                ref.read(userProvider.notifier).signout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
