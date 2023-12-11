import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if  (settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
    }else if (settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted provision permission');
    }else {
      print('User denied permission');
    }
  }
}