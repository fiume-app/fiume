import 'package:flutter/material.dart';

class ButtonWithLoading extends StatefulWidget {
  const ButtonWithLoading({Key? key, required this.onPressed, required this.child, this.width, this.height}) : super(key: key);

  final Future<void> Function() onPressed;

  final Widget child;

  final double? width;

  final double? height;

  @override
  _ButtonWithLoadingState createState() => _ButtonWithLoadingState();
}

class _ButtonWithLoadingState extends State<ButtonWithLoading> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: SizedBox(
          height: widget.height,
          width: widget.width,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              await widget.onPressed.call();
              setState(() {
                _loading = false;
              });
            },
            child: _loading ? Container() : widget.child,
          ),
        ),
        secondChild: const SizedBox(
          height: 40,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: CircularProgressIndicator(),
          ),
        ),
        crossFadeState: _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
    );
  }
}
