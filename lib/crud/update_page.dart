import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:realtime_crud_and_otp/getx_controller/controller.dart';
import 'package:realtime_crud_and_otp/getx_controller/notificationServices.dart';
import 'package:realtime_crud_and_otp/model/user_data_model.dart';

class UpdatePage extends StatefulWidget {

  String name;
  String email;
  String id;

   UpdatePage({super.key, required this.name, required this.email, required this.id});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  DatabaseReference database = FirebaseDatabase.instance.ref();
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  bool isUpdating = false;
  Controller controller = Get.put(Controller());
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    userName = TextEditingController(text: widget.name);
    userEmail = TextEditingController(text: widget.email);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.indigoAccent,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text('Update Your Data',style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InkWell(
                  child: CircleAvatar(
                    maxRadius: 70,
                    backgroundColor: Colors.indigoAccent,
                  ),
                ),

                SizedBox(height: 30,),
                _buildTextField(userName, 'UserName'),

                SizedBox(height: 30,),
                _buildTextField(userEmail, 'UserEmail'),

                SizedBox(height: 30,),
                ElevatedButton( onPressed: () {
                  updateData();
                },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10)
                    ),
                    child: isUpdating ?
                    const SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Text('Loding..',style: TextStyle(color: Colors.white),),
                          SizedBox(width: 10,),
                          SizedBox(
                            height: 25,
                            child: CircularProgressIndicator(color: Colors.white,),
                          )
                        ],
                      ),
                    )
                        : Text('Update',style: TextStyle(color: Colors.white),))

              ],
            ),
          )),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}){
    return Card(
      elevation: 10,
      shadowColor: Colors.orangeAccent,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.only(left: 15),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent)),
          disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent)),

        ),
      ),
    );
  }


  void updateData()async{

    var name = userName.text;
    var email = userName.text;
    var update = 'Your data has been update successfully';


    if(name.isNotEmpty && email.isNotEmpty){
      startProsses();
      String id = widget.id;

      var updateData = UserDataModel(
          id: id,
          name: userName.text,
          email: userEmail.text

      );

     await controller.updateData(updateData);
     notificationServices.showNotification(name, update);
     stopProsses();
     Navigator.pop(context);


    }else{
      Fluttertoast.showToast(msg: 'Please fell ol feald');
      stopProsses();

    }
  }


  void startProsses(){
    setState(() {
      isUpdating = true;
    });
  }

  void stopProsses(){
    setState(() {
      isUpdating = false;
    });
  }

}
