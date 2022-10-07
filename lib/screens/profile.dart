import 'package:fiume/providers/user.dart';
import 'package:fiume/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          /*Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('Sign Out'),
              onPressed: () {
                ref.read(userProvider.notifier).signout();
              },
            ),
          ),*/
          Padding(padding: EdgeInsets.all(20)),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ListTile(
                  title: Text('Orders'),
                  leading: Icon(Icons.inventory_2_outlined),
                  onTap: () {
                    context.push("/orders");
                  },
                ),
                ListTile(
                  title: Text('Bag'),
                  leading: Icon(Icons.shopping_bag_outlined),
                  onTap: () {
                    context.push("/bag");
                  },
                ),
                ListTile(
                  title: Text('Sign Out'),
                  leading: Icon(Icons.logout_outlined),
                  onTap: () {
                    ref.read(userProvider.notifier).signout();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
