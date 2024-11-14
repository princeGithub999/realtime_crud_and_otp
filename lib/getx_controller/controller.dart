import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../model/user_data_model.dart';



class Controller extends GetxController{

  // List<UserDataModel> itemList = [];

  DatabaseReference reference = FirebaseDatabase.instance.ref('User');


  Future<void> addUser(UserDataModel data)async{

    try{
      await reference.child(data.id.toString()).set(data.toMap());

    }catch(s){
      Fluttertoast.showToast(msg: 'Controller Error $s');
    }
  }


  Future<void> deleteItem(String id)async{
  final data = await reference.child(id).get();

  try{
    if(data.exists){
      reference.child(id).remove();
      Fluttertoast.showToast(msg: 'Delete item');
    }else{
      Fluttertoast.showToast(msg: 'data with this id dose not exist');

    }
  }catch(e){
      Fluttertoast.showToast(msg: '$e');
  }

  }

Future<void> updateData(UserDataModel updateData)async{
    final id = updateData.id;
  try{
    reference.child(id).update(updateData.toMap());
    await Fluttertoast.showToast(msg: 'Update success');

  }catch(e){
    await Fluttertoast.showToast(msg: 'Update Error $e');
  }
}


}


