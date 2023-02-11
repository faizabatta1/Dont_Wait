// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
//
// class Storage{
//   static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
//
//   static Future uploadUserImage({required File image, required String imageName}) async{
//     Reference ref = firebaseStorage.ref().child("users/${imageName}");
//     var image_url;
//     UploadTask uploadTask = ref.putFile(image);
//     await uploadTask.whenComplete(() async{
//       var url = await ref.getDownloadURL();
//       image_url = url.toString();
//     }).catchError((onError){
//       print(onError);
//     });
//
//     return image_url;
//   }
//
//   static Future uploadCentreImage({required File image,required String imageName}) async{
//     Reference ref = firebaseStorage.ref().child("centres/$imageName");
//     var image_url;
//     UploadTask uploadTask = ref.putFile(image);
//     await uploadTask.whenComplete(() async{
//       var url = await ref.getDownloadURL();
//       image_url = url.toString();
//     }).catchError((onError){
//       print(onError);
//     });
//   }
// }