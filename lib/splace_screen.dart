import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtime_crud_and_otp/request_otp.dart';

import 'home_page.dart';


class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {


  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

 Timer(Duration(seconds: 2), () {

   if(auth.currentUser != null){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));

   }else{
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestOtp(),));

   }
 },);
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [

                Color(0xFF1A237E).withOpacity(0.5),
                Colors.white


              ]

          )
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/images/undraw_verified_re_4io7 1 (1).png'),
        ),
      ),
      ),
    ) ;
  }
}
