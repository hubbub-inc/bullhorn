import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import 'dart:core';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:blips/services/shared_prefs.dart';
import 'package:blips/viewmodels/blipsview.dart';
import 'package:blips/services/user_service.dart';
import 'package:blips/services/image_service.dart';
import 'package:blips/services/notification_service.dart';
import 'package:blips/providers/auth_provider.dart';
import 'package:blips/providers/blips_provider.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/providers/chat_provider.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/routers.dart';



  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await sharedPrefs.init();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    BlipsViewModel blipsViewModel = BlipsViewModel();

    UserService userService = UserService();
    ImageService imageService = ImageService();

    NotificationService notificationService = NotificationService();
    notificationService.init();


  runApp(MultiProvider(
    providers: [
                ChangeNotifierProvider(create: (context) => AuthProvider()),
                ChangeNotifierProvider(create: (context) => BlipsProvider(blipsViewModel)),
                ChangeNotifierProvider(create: (context) => UserProvider(userService)),
                ChangeNotifierProvider(create: (context) => PhotoProvider(imageService)),
                ChangeNotifierProvider(create: (context) => LocationProvider()),
               ChangeNotifierProvider(create: (context) => MessagingProvider(messaging, notificationService)),
               ChangeNotifierProvider(create: (context) => ChatProvider()),
                ],
    child: MaterialApp(
              initialRoute: 'landing',
              onGenerateRoute: Routers.generateRoute,
    )
  ));
  }







