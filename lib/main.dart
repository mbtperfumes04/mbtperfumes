import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/admin/screens/admin_start.dart';
import 'package:mbtperfumes/providers/cart_provider.dart';
import 'package:mbtperfumes/providers/category_provider.dart';
import 'package:mbtperfumes/providers/custom_order_provider.dart';
import 'package:mbtperfumes/providers/custom_product_provider.dart';
import 'package:mbtperfumes/providers/favorite_product_provider.dart';
import 'package:mbtperfumes/providers/notes_scent_provider.dart';
import 'package:mbtperfumes/providers/order_provider.dart';
import 'package:mbtperfumes/providers/payment_provider.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:mbtperfumes/providers/search_provider.dart';
import 'package:mbtperfumes/screens/home.dart';
import 'package:mbtperfumes/screens/hub.dart';
import 'package:mbtperfumes/themes/light.dart';
import 'package:provider/provider.dart';
import 'package:resend/resend.dart';
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
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProductProvider()),
      ChangeNotifierProvider(create: (_) => NotesScentsProvider()),
      ChangeNotifierProvider(create: (_) => CustomProductProvider()),
      ChangeNotifierProvider(create: (_) => CustomOrderProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider())
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
    print('Loading data from supabase');
    await Provider.of<CategoryProvider>(context, listen: false).initData();
    await Provider.of<ProductProvider>(context, listen: false).initData();
    await Provider.of<FavoriteProductProvider>(context, listen: false).initData();

    print('Data all loaded');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    Resend(apiKey: 're_VeSuDtEp_Kqvvkyh2i8LUYUygGB84DFir');
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenSize = screenHeight + screenWidth;
    return GetMaterialApp(
      title: 'Scentopia',
      debugShowCheckedModeBanner: false,
      theme: light.copyWith(
        textTheme: light.textTheme.apply(fontFamily: 'Poppins')
      ),
      home: supabase.auth.currentUser != null ?
      (supabase.auth.currentUser?.userMetadata?['role'] != 'Customer' ? const AdminStart() : const Hub()) : const Hub()
    );
  }
}
