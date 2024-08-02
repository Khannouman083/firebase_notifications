import 'package:firebase_notifications/notification_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  NotificationServices notificationServices = NotificationServices();
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPersmission();
    notificationServices.handleInteractMessage(context);
    notificationServices.getDeviceToken().then((value){
      print(value);
    }).catchError((error){
      print(error);
    });
    notificationServices.fireBaseInit(context);
    // notificationServices.refreshToken();




  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.green,
      ),

    );
  }
}
