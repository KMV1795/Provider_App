import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/firebase_options.dart';
import 'package:provider_app/view_screens/login_page.dart';
import 'Services/login_provider.dart';
import 'view_screens/qr_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
      ],
      child: const MaterialApp(
        title: 'QR Demo App',
        debugShowCheckedModeBanner: false,
        home: ScreensController(),
      ),
    );
  }
}

class ScreensController extends StatelessWidget {
  const ScreensController({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<LoginProvider>(context);
    if (auth.isLoggedIn == true) {
      return const QrPage(
        ip: '',
        location: '',
        loginDate: '',
        loginTime: '',
      );
    } else {
      return const LoginPage();
    }
  }
}
