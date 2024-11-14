import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:realtime_crud_and_otp/request_otp.dart';

import 'home_page.dart';

class VerifyOtp extends StatefulWidget {
  String verificationId;
   VerifyOtp({super.key, required this.verificationId});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}



class _VerifyOtpState extends State<VerifyOtp> {


  TextEditingController otpText = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isVerify = false;
  OtpTimerButtonController timerButtonController = OtpTimerButtonController();


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
                      Text('OTP Verification',style: TextStyle(color: Colors.white,fontSize: 26),),

                      SizedBox(height: 10,),
                      // Text('We have send you an OTP on this mobile number',style: TextStyle(color: Colors.white,fontSize: 17),),


                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Image.asset('assets/images/undraw_verified_re_4io7 1 (1).png'),
                      ),





                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Align(
                         child:  Pinput(

                            controller: otpText,
                           keyboardType: TextInputType.number,
                           length: 6,

                         ),
                       ),
                     ),


                      SizedBox(height: 20,),
                      Align(
                        child:  OtpTimerButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestOtp(),));
                        },
                          controller: timerButtonController,
                          radius: 5,
                          buttonType: ButtonType.elevated_button,
                          text: Text('Resend OTP'),
                          duration: 30,
                          loadingIndicator: CircularProgressIndicator(color: Colors.white,),


                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: ElevatedButton(onPressed: () {
                            verifyOtpF();
                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1A237E).withOpacity(0.5),
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                            ),

                            child: isVerify ?
                            const SizedBox(
                              width: 110,
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
                                :Text('Verifys OTP',style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                ),
              )
          ),
        )

    );

  }


  void verifyOtpF() async{

    var otp = otpText.text;

    if(otp.isNotEmpty){
      try{
        startProsses();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: widget.verificationId, smsCode: otp
        );
        await  auth.signInWithCredential(credential);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));


      }on FirebaseAuthException catch(e) {
        stopProsses();
        Fluttertoast.showToast(msg: 'Authentication Error: ${e.message}');

      }
      catch(s){
        stopProsses();
        Fluttertoast.showToast(msg: 'Error $s');
      }
    }else{
      Fluttertoast.showToast(msg: 'Please enter otp');
    }

  }

  void startProsses(){
    setState(() {
      isVerify = true;
    });
  }

  void stopProsses(){
    setState(() {
      isVerify = false;
    });
  }
}
