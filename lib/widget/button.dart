import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  String name;
  VoidCallback child;
  Color colors;

  Button(
      {super.key,
        required this.name,
        required this.child,
        this.colors = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 2, right: 24),
      child: GestureDetector(
        onTap: child,
        child: Container(
          height: 54,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.all(Radius.circular(57))),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
