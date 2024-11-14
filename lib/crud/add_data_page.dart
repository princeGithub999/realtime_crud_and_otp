import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_string/random_string.dart';
import 'package:realtime_crud_and_otp/getx_controller/notificationServices.dart';
import '../getx_controller/controller.dart';
import '../model/user_data_model.dart';



class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();


  bool isAdding = false;

  NotificationServices notificationServices = NotificationServices();
  Controller controller = Get.put(Controller());
  var userList = [].obs;
  final userId = randomAlphaNumeric(10);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.indigoAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Your Data',style: TextStyle(color: Colors.white),),
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

            const SizedBox(height: 30,),
            _buildTextField(userName, 'UserName'),

            SizedBox(height: 30,),
            _buildTextField(userEmail, 'UserEmail'),

            const SizedBox(height: 30,),
            ElevatedButton( onPressed: () {
              addProsess();
            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10)
                ),
                child: isAdding ?
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
                    : Text('Add Data',style: TextStyle(color: Colors.white),))

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




  Future<void>  addProsess() async{
    var name = userName.text.toString();
    var email = userEmail.text.toString();
    var add = 'Your data has been added successfully';

    if(name.isNotEmpty && email.isNotEmpty){

      try{
        startProsses();
        var data = UserDataModel(id: userId.toString(), name: name, email: email);
         await controller.addUser(data);
         Fluttertoast.showToast(msg: 'Add data success');
         await notificationServices.showNotification(name,add);
        stopProsses();
        Navigator.pop(context);
      }catch(s){
        Fluttertoast.showToast(msg: 'Add Error $s');
        stopProsses();
      }
    }else{
      Fluttertoast.showToast(msg: 'Please Enter all feald');
      stopProsses();
    }
  }

  void startProsses(){
    setState(() {
      isAdding = true;
    });
  }

  void stopProsses(){
    setState(() {
      isAdding = false;
    });
  }
}
