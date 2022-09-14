import 'package:flutter/material.dart';

class AppBarBottomLine extends StatelessWidget {
  const AppBarBottomLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.grey,
      height: 1.0,
      width: MediaQuery.of(context).size.width * 2 / 15,
    );
  }
}
