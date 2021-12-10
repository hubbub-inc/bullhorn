import 'package:flutter/material.dart';
import 'dart:core';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:blips/services/user_service.dart';
import 'package:blips/services/notification_service.dart';
import 'package:blips/providers/user_provider.dart';

class MessagingProvider with ChangeNotifier {
  late FirebaseMessaging messaging;
  late NotificationService notificationService;
  late UserProvider userProvider;
  static int semaphore = 0;



  bool _hasMessage = false;
  bool get hasMessage => _hasMessage;

  MessagingProvider(this.messaging, this.notificationService);

  void initializeMessaging(UserProvider userProvider) {
    userProvider = userProvider;





    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (semaphore != 0) {
        return;
      }
      semaphore = 1;
      Future.delayed(Duration(seconds: 1)).then((_) => semaphore = 0);
      print("message recieved");
      print(event.notification!.body);
      if (event.notification?.body!=null) {
        final content = event.notification?.body!;
        if (content!=null) {
          userProvider.updateNotifications(content);
          notificationService.showNotification(content);

      }}

      notifyListeners();


  });
          }

  void dismissNotification() {
      _hasMessage = false;
      notifyListeners();
  }

  void subscribeToBlip(String blipId) {
      print("subscribing to blip");
      print(blipId);
      messaging.subscribeToTopic(blipId);
  }

  void unSubscribeToBlips(String blipId) {
      messaging.unsubscribeFromTopic(blipId);
  }
}
