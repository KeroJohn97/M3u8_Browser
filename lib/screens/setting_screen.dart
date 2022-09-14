import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/text_helper.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(TextHelper.settings.tr),
        ),
      ),
    );
  }
}
