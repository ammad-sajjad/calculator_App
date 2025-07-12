import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class menuItem extends StatelessWidget {
  const menuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          color: Colors.orange[300],

        ),

        Container(
          height: 50,
          color: Colors.orange[200],
        ),

        Container(
          height: 50,
          color: Colors.orange[100],
        ),
      ],
    );
  }
}
