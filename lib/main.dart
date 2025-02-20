import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mbtperfumes/screens/home.dart';
import 'package:mbtperfumes/themes/light.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'globals.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Supabase.initialize(
    url: 'https://dazuyanxytepiineldkc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRhenV5YW54eXRlcGlpbmVsZGtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAwNDI3MzQsImV4cCI6MjA1NTYxODczNH0.C4yUvw5VibYAUEM_BpWCRwF0Qux5YmVb40hIMhtOJpA',
  );

  runApp(const Start());
}

final supabase = Supabase.instance.client;

class Start extends StatelessWidget {
  const Start({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenSize = screenHeight + screenWidth;
    return MaterialApp(
      title: 'Scentopia',
      debugShowCheckedModeBanner: false,
      theme: light,
      home: const Home()
    );
  }
}
