import 'dart:convert';

import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'Signup/hex.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dont_wait/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

var channel;
var flutterLocalNotificationsPlugin;

void loadFCM() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

}

void listenFCM() async {
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print("event => ${event.notification!.body}");
  // });


  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    var initializationSettingsAndroid =  AndroidInitializationSettings('logo');
    if (notification != null && android != null) {
      await pushUserNotification(
          id: message.data['userId'],
          title: notification.title!,
          body: notification.body!
      );

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // TODO.txt add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: initializationSettingsAndroid.defaultIcon,
          ),
        ),
      );
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  requestPermission();
  loadFCM();
  listenFCM();

  SharedPreferences sp = await SharedPreferences.getInstance();
  bool logged = sp.getBool('logged') ?? false;
  UserType userType = await determineUserType(sp.getString('id') ?? '');
  Map userData = jsonDecode(sp.getString('userData') ?? '{}');

  runApp(
      UiApp(logged:logged,userType:userType,userData:userData)
  );

}

class UiApp extends StatelessWidget {

  final Color _primaryColor = HexColor('##008080');
  final Color _accentColor = HexColor('##008080');
  final bool logged;
  final UserType userType;
  final Map userData;

  UiApp({super.key, required this.logged, required this.userType, required this.userData});

  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8')

  // Our Logo Blue Color
  //Color _primaryColor= HexColor('#651BD2');
  //Color _accentColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // i can here share anything across the whole app without passing it in a constructor
    // for multiProviding use MultiProvider
    return ChangeNotifierProvider(
      create: (_) => AuthChangeNotifier(logged:logged,userType: userType,userData: userData),
      child: MaterialApp(
        title: 'Dont Wait!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: _primaryColor,
          scaffoldBackgroundColor: Colors.grey.shade100, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: _accentColor),
        ),
          home: SplashScreen(title: 'Dont Wait!')
      ),
    );
  }
}

