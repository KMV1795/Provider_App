import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/view_screens/qr_page.dart';
import '../Services/auth_provider.dart';
import 'login_screen.dart';
import 'package:local_auth/local_auth.dart';

class ScreensController extends StatefulWidget {
  const ScreensController({super.key});

  @override
  State<ScreensController> createState() => _ScreensControllerState();
}

class _ScreensControllerState extends State<ScreensController>
    with WidgetsBindingObserver {
  final localAuth = LocalAuthentication();

  final isBiometricAvailable = LocalAuthentication().canCheckBiometrics;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isDetached = state == AppLifecycleState.detached;
    if (isDetached) {
      authenticate();
    }
  }

  Future<void> authenticate() async {
    final isBiometricAvailable = await localAuth.canCheckBiometrics;
    if (isBiometricAvailable) {
      final isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to continue',
        // biometricOnly: true,
      );
      if (isAuthenticated) {
        // ignore: use_build_context_synchronously
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (auth.isSignedIn == true) {
          auth.getDataFromSP();
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QrPage(
                  loginTime: '', loginDate: '', location: '', ip: ''),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isSignedIn == true) {
      auth.getDataFromSP();
      return const QrPage(
        ip: '',
        location: '',
        loginDate: '',
        loginTime: '',
      );
    } else {
      return const LoginScreen();
    }
  }
}
