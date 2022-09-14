import 'dart:convert';

import 'package:flutter/services.dart';

class Secret {
  final String buyMeACoffee;
  Secret({
    required this.buyMeACoffee,
  });

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(
      buyMeACoffee: jsonMap['buy_me_a_coffee'],
    );
  }
}

class SecretLoader {
  final String secretPath;
  SecretLoader({required this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(secretPath, (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}

Future<Secret> secretKey = SecretLoader(secretPath: "secret_key.json").load();
