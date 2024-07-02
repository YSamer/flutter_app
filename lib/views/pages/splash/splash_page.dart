import 'package:flutter_app/core/extensions/assetss_widgets.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';
import 'package:flutter_app/providers/splash/splash_provider.dart';
import 'package:flutter_app/views/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashProvider>(
      create: (context) => SplashProvider(),
      builder: (context, child) => Consumer<SplashProvider>(
        builder: (context, provider, child) {
          if (provider.authUserResult == true) {
            Future.microtask(
              () => AppRoutes.routeRemoveTo(context, const HomePage()),
            );
          } else if (provider.authUserResult == false) {
            // Login Page
            Future.microtask(
              () => AppRoutes.routeRemoveTo(context, const HomePage()),
            );
          }
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Spacer(),
                  const FlutterLogo(
                    size: 100,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 2,
                    ),
                  ),
                  32.hSize,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
