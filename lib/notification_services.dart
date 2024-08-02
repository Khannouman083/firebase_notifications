import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications/message_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void initLocalFlutter (BuildContext context, RemoteMessage message) async{
    var androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
    onDidReceiveNotificationResponse: (payload){
        messageHandle(context, message);
    });
  }

  Future<void> showNotification (RemoteMessage message) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
      "This is a High Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      channelDescription: "this is the description of channel",
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
       presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
     NotificationDetails _notificationDetails = NotificationDetails(
       android: _androidNotificationDetails,
       iOS: darwinNotificationDetails,
     );
     Future.delayed(Duration.zero, (){
       _flutterLocalNotificationsPlugin.show(
           1,
           message.notification!.title.toString(),
           message.notification!.body.toString(),
           _notificationDetails);
     });
  }
  void fireBaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (Platform.isAndroid) {
          initLocalFlutter(context, message);
          showNotification(message);
        }
        if (kDebugMode) {
          print(message.notification!.title);
          print(message.notification!.body);
          print(message.data.toString());
          print(message.data['title']);
        }

        showNotification(message);
      }
    });
  }

  Future<void> handleInteractMessage (BuildContext context) async{
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage!=null){
      messageHandle(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event){
      messageHandle(context, event);
    });
  }

  void messageHandle (BuildContext context, RemoteMessage message){
    if (message.data['title'] == 'Nomii'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> messageScreen(id: message.data['id'].toString())));
    }

  }
  void requestNotificationPersmission() async{
     NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       announcement: true,
       badge: true,
       carPlay: true,
       sound: true,
       criticalAlert: true,
       provisional: true,
     );
     if(settings.authorizationStatus == AuthorizationStatus.authorized){
        print("User authorized the persmissions");
     }
     else if(settings.authorizationStatus == AuthorizationStatus.provisional){
       print("User authorized the persmissions provisionally");


     }
     else if(settings.authorizationStatus == AuthorizationStatus.denied){
       print("User denied the permissions");
     }
  }

  Future<String> getDeviceToken() async{
    String? token =  await messaging.getToken();
    return token!;
  }

  void refreshToken() async{
    messaging.onTokenRefresh.listen((event){
      print(event.toString());
    });
  }
}