import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:realtime_crud_and_otp/splace_screen.dart';
import 'firebase_options.dart';
import 'getx_controller/notificationServices.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    NotificationServices notificationServices  = NotificationServices();
    notificationServices.initializeNotifications();


    runApp(const MyApp());
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
    );
  }
}
