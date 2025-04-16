import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/providers/category_provider.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:mbtperfumes/screens/home.dart';
import 'package:mbtperfumes/screens/hub.dart';
import 'package:mbtperfumes/themes/light.dart';
import 'package:provider/provider.dart';
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider())
    ],
    child: const Start(),
  ));
}

final supabase = Supabase.instance.client;

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    await Provider.of<CategoryProvider>(context, listen: false).initData();
    await Provider.of<ProductProvider>(context, listen: false).initData();

   FlutterNativeSplash.remove();
    print("Test");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenSize = screenHeight + screenWidth;
    return GetMaterialApp(
      title: 'Scentopia',
      debugShowCheckedModeBanner: false,
      theme: light.copyWith(
        textTheme: light.textTheme.apply(fontFamily: 'Poppins')
      ),
      home: const Hub()
    );
  }
}
