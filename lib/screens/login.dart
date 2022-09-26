import 'package:email_validator/email_validator.dart';
import 'package:fiume/providers/user.dart';
import 'package:fiume/widgets/button_with_loading.dart';
import 'package:fiume/widgets/error_dialog_v1.dart';
import 'package:fiume/widgets/logo.dart';
import 'package:fiume/widgets/password_reset_dialog_v1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiume'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              logoSvg,
              Spacer(),
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
              Padding(padding: EdgeInsets.all(5)),
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                      text: 'Forgot Password ?',
                      style: Theme.of(context).textTheme.caption?.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(context: context, builder: (context) => PasswordResetDialogV1());
                        }
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: ButtonWithLoading(
                  height: 50,
                  width: double.infinity,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      OpRet ret = await ref.read(userProvider.notifier).signin(_email, _password);

                      if (ret.errorString != null) {
                        showDialog(
                            context: context,
                            builder: (context) => ErrorDialogV1(errorString: ret.errorString!)
                        );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Don't have an account? ", style: Theme.of(context).textTheme.caption),
                    TextSpan(
                      text: 'SignUp',
                      style: Theme.of(context).textTheme.caption?.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/login/signup');
                        }
                    ),
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
