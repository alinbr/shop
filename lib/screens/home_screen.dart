import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers_riverpod/auth_controller.dart';
import 'package:shop/screens/products_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';

import 'auth_screen.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.isAuth
        ? ProductOverviewScreen()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : AuthScreen(),
          );
  }
}
