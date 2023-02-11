import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService{
  static FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  static Future fetchTestTime (String key) async{
    String? time = "";
    // Query x = firebaseDatabase.ref().child("times");
    // Map values = x.get()
    //     x.once().then((event){
    //   Object? values = event.snapshot.value;
    //   // time = values![key];
    // });
    List<DataSnapshot> data = (await firebaseDatabase.ref("times").get()).children.toList();
    data.forEach((element) {
      time = (element.key == key ? element.value : time) as String?;
    });

    return time;
  }
}