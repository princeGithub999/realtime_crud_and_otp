import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:realtime_crud_and_otp/crud/update_page.dart';
import 'package:realtime_crud_and_otp/getx_controller/controller.dart';
import 'package:realtime_crud_and_otp/getx_controller/notificationServices.dart';
import 'package:realtime_crud_and_otp/model/user_data_model.dart';
import 'crud/add_data_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  NotificationServices notificationServices  = NotificationServices();
 final DatabaseReference database = FirebaseDatabase.instance.ref();
 List<UserDataModel> listOfData = [];
 bool isLoding = false;
 Controller controller = Get.put(Controller());


 @override
  void initState() {
    super.initState();
    getData();
   notificationServices.requestNotificationPermission();

   notificationServices.getToken().then((value) {
     print('device token $value');
   },);

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Real Time crud',style: TextStyle(color: Colors.white),), backgroundColor: Colors.indigo,
      ),
      body:  SafeArea(child:
          isLoding ? Center(child: CircularProgressIndicator(),):
              
          listOfData.isNotEmpty?    
          ListView.builder(
            itemCount: listOfData.length,
              itemBuilder: (context, index){

              final data = listOfData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
              child:  Card(
                color: Colors.white38,
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.indigoAccent,
                  maxRadius: 30,
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                  title: Text(listOfData[index].name,style: TextStyle(color: Colors.indigoAccent,fontSize: 20),),
                  subtitle: Text(listOfData[index].email),
                  trailing: isLoding ? CircularProgressIndicator(): IconButton(onPressed: () async{

                   await controller.deleteItem(listOfData[index].id);
                  await getData();
                  notificationServices.showNotification(listOfData[index].name, 'delete');
                  }, icon: Icon(Icons.delete)),

                  onLongPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(
                        name: data.name,
                        email: data.email,
                        id: data.id
                    ),));
                  },
                ),
              ),
            );
          }):Center(child: Text('data is not avlable'),)
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataPage(),));
      }, label: const Text('Add'),
        backgroundColor: Colors.indigoAccent,
        autofocus: true,
        elevation: 10,
      icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }

  Future<void> getData()async{
   startProsess();
    database.child('User').onValue.listen((event) {
      final dataSnapShot = event.snapshot.value as Map<dynamic, dynamic>?;
      final List<UserDataModel> tempDataList = [];

      if(dataSnapShot != null){
        dataSnapShot.forEach((key, value) {
          final userList = UserDataModel.fromJson(Map<String, dynamic>.from(value));
          tempDataList.add(userList);
        },);
      }

      setState(() {
        listOfData = tempDataList;
        stopProsess();
      });

    },);
   }



   void startProsess(){
      setState(() {
        isLoding = true;
      });
   }

 void stopProsess(){
   setState(() {
     isLoding = false;
   });
 }

}
