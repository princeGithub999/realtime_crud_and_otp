import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realtime_crud_and_otp/verifye_otp.dart';

class RequestOtp extends StatefulWidget {
  const RequestOtp({super.key});

  @override
  State<RequestOtp> createState() => _RequestOtpState();
}

class _RequestOtpState extends State<RequestOtp> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController phoneNumber = TextEditingController();
  bool isRequest = false;

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
          body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,top: 40,right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verify your \nphone number',style: TextStyle(color: Colors.white,fontSize: 26),),

                      SizedBox(height: 10,),
                      Text('We have send you an OTP on this mobile number',style: TextStyle(color: Colors.white,fontSize: 17),),


                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Image.asset('assets/images/undraw_secure_login_pdn4 1 (1).png'),
                      ),


                    Card(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneNumber,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none
                        ),
                      ),
                    ),




                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: ElevatedButton(onPressed: () {
                          requestOtp();
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1A237E).withOpacity(0.5),
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                            ),

                            child: isRequest ?
                                const SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      Text('Sending...',style: TextStyle(color: Colors.white),),
                                      SizedBox(width: 10,),
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(color: Colors.white,),
                                      )
                                    ]
                                  ),
                                )
                                :Text('Sent OTP',style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                ),
              )
          ),
        )

    );
  }


  void requestOtp()async{

    var number = phoneNumber.text;
    if(number.isNotEmpty){
      startProsses();
       _auth.verifyPhoneNumber(
            phoneNumber: '+91$number',
           verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
              stopProsses();
           },
           verificationFailed: (FirebaseAuthException error) {
              Fluttertoast.showToast(msg: '$error');
              stopProsses();
           },
           codeSent: (String verificationId, int? forceResendingToken) {


             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyOtp(verificationId:verificationId),));
             stopProsses();
           },
           codeAutoRetrievalTimeout: (String verificationId) {
              stopProsses();
           }

      );

    }else{
        Fluttertoast.showToast(msg: 'please enter phone number');
    }

  }


  void startProsses(){
    setState(() {
      isRequest = true;
    });
  }

  void stopProsses(){
    setState(() {
      isRequest = false;
    });
  }
}
