import 'package:fiume/models/address.dart';
import 'package:fiume/models/error.dart';
import 'package:fiume/providers/address.dart';
import 'package:fiume/widgets/button_with_loading.dart';
import 'package:fiume/widgets/error_dialog_v1.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddressDialogV1 extends ConsumerStatefulWidget {
  const AddressDialogV1({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddressDialogV1State();
}

class _AddressDialogV1State extends ConsumerState<AddressDialogV1> {
  final _formKey = GlobalKey<FormState>();

  String _line1 = '';
  String _line2 = '';
  String _city = '';
  String _state = '';
  String _pinCode = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Row(
          children: [
            Text('Add Address'),
            Spacer(),
            CloseButton(),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _line1 = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Line 1',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Address Line1';
                    }

                    return null;
                  },
                  maxLines: 2,
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _line2 = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Line 2',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Address Line2';
                    }

                    return null;
                  },
                  maxLines: 2,
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _city = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter City';
                    }

                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _state = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter State';
                    }

                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onChanged: (v) {
                    setState(() {
                      _pinCode = v;
                    });
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Pin Code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Pin Code';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ButtonWithLoading(
            child: const Text('Add'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await ref.read(addressProvider.notifier).addAddress(
                    PostAddressParams(
                      line1: _line1,
                      line2: _line2,
                      city: _city,
                      state: _state,
                      pinCode: _pinCode,
                    )
                  );

                  if (!mounted) {
                    return;
                  }

                  Navigator.pop(context);
                } catch (e) {
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context) => ErrorDialogV1(errorString: (e as ApiErrorV1).msg));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
