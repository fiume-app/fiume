import 'package:fiume/providers/address.dart';
import 'package:fiume/widgets/address_dialog_v1.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwitchAddressDialogV1 extends ConsumerStatefulWidget {
  const SwitchAddressDialogV1({
    Key? key,
    required this.initVal,
    required this.cb,
  }) : super(key: key);

  final String initVal;
  final void Function(String) cb;

  @override
  ConsumerState createState() => _SwitchAddressDialogV1State();
}

class _SwitchAddressDialogV1State extends ConsumerState<SwitchAddressDialogV1> {
  String _val = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Text('Select Address'),
          Spacer(),
          CloseButton(),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: ref.watch(addressProvider).map((e) => ListTile(
              title: Text(e.city),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.line1, style: Theme.of(context).textTheme.caption),
                  Text(e.line2 ?? '', style: Theme.of(context).textTheme.caption),
                  Text(e.city, style: Theme.of(context).textTheme.caption),
                  Text(e.state, style: Theme.of(context).textTheme.caption),
                  Text(e.pinCode, style: Theme.of(context).textTheme.caption),
                ],
              ),
              leading: Radio(
                value: e.id,
                groupValue: _val.length == 0 ? widget.initVal : _val,
                onChanged: (v) {
                  setState(() {
                    _val = v!;
                  });
                  widget.cb(v!);
                },
              ),
              onTap: () {
                setState(() {
                  _val = e.id;
                });
                widget.cb(e.id);
              },
            )).toList(),
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => const AddressDialogV1());
            },
            child: const Text('Add Address'),
          )
        ),
      ],
    );
  }
}
