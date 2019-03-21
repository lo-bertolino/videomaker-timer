import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double height;
  final bool enabled;
  final Function() onPressed;
  final String text;
  final Color color;

  const Button({
    Key key,
    this.height,
    this.enabled,
    this.onPressed,
    this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 400,
      height: height,
      child: RaisedButton(
        color: color,
        textColor: Colors.black87,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
