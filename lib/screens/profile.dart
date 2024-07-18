import 'package:fiume/providers/payment_gateway.dart';
import 'package:fiume/providers/user.dart';
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
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                  child: Icon(Icons.account_circle, size: 150)
              ),
              Text(ref.read(userProvider)!.apiUser!.name, style: Theme.of(context).textTheme.headlineMedium),
              Text(ref.read(userProvider)!.apiUser!.email, style: Theme.of(context).textTheme.labelLarge),
              const Padding(padding: EdgeInsets.all(20)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Orders'),
                      leading: const Icon(Icons.inventory_2_outlined),
                      onTap: () {
                        context.push("/orders");
                      },
                      onLongPress: () {
                        ref.read(paymentGatewayProvider.notifier).setVal(!ref.watch(paymentGatewayProvider)!);
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: Text('Payment Gateway ${ref.watch(paymentGatewayProvider) ? 'Enabled': 'Disabled' }'),
                          actions: [
                            ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text('Ok'))
                          ],
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('Bag'),
                      leading: const Icon(Icons.shopping_bag_outlined),
                      onTap: () {
                        context.push("/bag");
                      },
                    ),
                    ListTile(
                      title: const Text('Sign Out'),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () {
                        ref.read(userProvider.notifier).signout();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
