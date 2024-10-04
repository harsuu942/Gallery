import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_app/ui/my_app.dart';

/// The main entry point of the application.
Future<void> main() async {


  runApp(const ProviderScope(child: MyApp()));
}
