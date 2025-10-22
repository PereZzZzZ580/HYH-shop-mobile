import 'package:flutter/material.dart';

import 'package:hyhshopmobile/app/app.dart';
import 'package:hyhshopmobile/services/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initialize();
  runApp(const HyHShopMobileApp());
}
