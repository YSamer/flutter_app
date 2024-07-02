import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/data/local/local_data.dart';
import 'package:flutter_app/core/extensions/assetss_widgets.dart';
import 'package:flutter_app/core/helpers/notification_helper.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';
import 'package:flutter_app/injections.dart';
import 'package:flutter_app/providers/app_provider.dart';
import 'package:flutter_app/views/pages/splash/splash_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  showNotificationD(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInj();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final RemoteMessage? message = await firebaseMessaging.getInitialMessage();
  FlutterError.onError = (FlutterErrorDetails details) {
    log("Error : ${details.exception}");
    log("StackTrace :  ${details.stack}");
  };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      // child: MyApp(message: message),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final RemoteMessage? message;
  const MyApp({super.key, this.message});
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    setLocale(getLocale);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationHelper();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => tr(context).app_name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Expo',
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const SplashPage(),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              child ?? const SizedBox(),
              if (LocalData.loadingActive &&
                  context.watch<AppProvider>().isLoading > 0) ...{
                InkWell(
                  onTap: () => removeAppLoading(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: 25.cBorder,
                    ),
                    child: const SpinKitPulsingGrid(
                      color: Colors.blue,
                    ),
                  ),
                ),
              }
            ],
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void showNotificationD(RemoteMessage payload) async {
  final localNotify = FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'channel id 3',
    'channel name',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await localNotify.show(
    math.Random().nextInt(99999999),
    payload.notification?.title ?? '',
    payload.notification?.body ?? '',
    platformChannelSpecifics,
    payload: json.encode(payload.data),
  );
}
