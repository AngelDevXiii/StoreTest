import 'package:flutter/material.dart';

class NumberStepper extends StatelessWidget {
  final int quantity;

  final void Function(int quantity) onPressed;

  const NumberStepper({
    super.key,
    required this.quantity,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => onPressed(quantity - 1),
        ),

        Text('$quantity'),

        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onPressed(quantity + 1),
        ),
      ],
    );
  }
}
