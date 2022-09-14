import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/asset_helper.dart';
import '../helpers/color_helper.dart';
import '../helpers/text_helper.dart';
import '../models/secret_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _textController = TextEditingController();

  void _launchUrl() async {
    final Secret secret = await secretKey;
    final result = await canLaunchUrl(Uri.parse(secret.buyMeACoffee));
    if (result) {
      await launchUrl(Uri.parse(secret.buyMeACoffee));
    }
  }

  void _sendFeedback() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryColor,
        elevation: 0.0,
      ),
      backgroundColor: ColorHelper.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AssetHelper.logoImage,
                fit: BoxFit.cover,
              ),
            ),
            CustomButton(
              voidCallback: _launchUrl,
              text: TextHelper.buyMeACoffee.tr,
              fontSize: 24.0,
              backgroundColor: Colors.orangeAccent,
              leading: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Image.asset(AssetHelper.coffeeImage),
              ),
              height: 100.0,
              width: MediaQuery.of(context).size.width - 32.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              TextHelper.or.tr,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  // color: Colors.white,
                ),
                child: CustomTextField(
                  controller: _textController,
                  hintText: TextHelper.tellMe.tr,
                  hintStyle: const TextStyle(
                    // color: Colors.black,
                    fontSize: 20.0,
                  ),
                  textStyle: const TextStyle(
                    // color: Colors.black,
                    fontSize: 20.0,
                  ),
                  maxLines: 5,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              voidCallback: _sendFeedback,
              text: TextHelper.send.tr,
              textColor: Colors.white,
              fontSize: 20.0,
              height: 50.0,
              width: 150.0,
              backgroundColor: Colors.purpleAccent,
            ),
          ],
        ),
      ),
    );
  }
}
