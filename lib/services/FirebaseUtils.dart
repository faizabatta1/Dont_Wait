import 'FirestoreService.dart';

class FirebaseUtils{
  static Future getDocumentRef({required String collection,required String uid}) async{
    var doc = (await FirestoreService.firestore.collection(collection).get()).docs.where((element) => element['uid'] == uid).first;
    var ref = doc.id;

    return ref;
  }
}