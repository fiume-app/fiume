import 'package:email_validator/email_validator.dart';
import 'package:fiume/widgets/button_with_loading.dart';
import 'package:fiume/widgets/error_dialog_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _conpassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                onChanged: (v) {
                  setState(() {
                    _name = v;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"^[A-Za-z]+[\s]?[A-Za-z]*$"))
                ],
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Name';
                  }

                  if (RegExp(r"^[A-Za-z]+[\s]?[A-Za-z]*$").hasMatch(value) == false) {
                    return 'Please Enter Valid Name';
                  }

                  return null;
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextFormField(
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                onChanged: (v) {
                  setState(() {
                    _email = v;
                  });
                },
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email';
                  }

                  if (EmailValidator.validate(value) == false) {
                    return 'Please enter Valid Email';
                  }

                  return null;
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextFormField(
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                onChanged: (v) {
                  setState(() {
                    _password = v;
                  });
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }

                  if (value.length < 8) {
                    return 'Password too weak';
                  }

                  return null;
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextFormField(
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                onChanged: (v) {
                  setState(() {
                    _conpassword = v;
                  });
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }

                  if (value != _password) {
                    return 'Password and confirm password not equal';
                  }

                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: ButtonWithLoading(
                  height: 50,
                  width: double.infinity,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      OpRet ret = await ref.read(userProvider.notifier).signup(
                        _email,
                        _password,
                        _name,
                      );

                      if (ret.errorString != null) {
                        showDialog(
                            context: context,
                            builder: (context) => ErrorDialogV1(errorString: ret.errorString!)
                        );
                      }
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "By Signing Up you agree to our Terms, Conditions and Privacy Policy ", style: Theme.of(context).textTheme.caption),
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
