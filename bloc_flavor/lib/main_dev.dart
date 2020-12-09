import 'dart:io';
import 'package:flutter/material.dart';

import 'main.dart';
import 'models/app_config.dart';

void main(List<String> args) {
  const String kPort = '3010';
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:$kPort' : 'http://localhost:$kPort';
  final String dataUrl = '$baseUrl/dev';

  final appConfig = AppConfig(
    baseUrl: baseUrl,
    dataUrl: dataUrl,
    buildFlavor: 'dev',
  );

  runApp(MyApp(appConfig: appConfig));
}
