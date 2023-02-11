import 'dart:convert';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<Map> loginUser({required String id,required String password}) async
{
  try
  {
    var uri = "http://10.0.2.2:3000/users/login";
    http.Response res = await http.post(Uri.parse(uri),
      body: jsonEncode({
        'id': id,
        'password': password
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return jsonDecode(res.body);

  } catch (e) {
    print(e);
    return {};
  }
}

Future updateUserToken({required String id,required String device_token}) async{
  try{
    var uri = "http://10.0.2.2:3000/users/$id/token/update";
    http.Response response = await http.post(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body:jsonEncode({
        'device_token':device_token
      })
    );
  }catch(error){
    print(error);
  }
}

Future removeUserToken({required String id}) async{
  try{
    var uri = "http://10.0.2.2:3000/users/$id/token/remove";
    http.Response response = await http.get(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      }
    );
  }catch(error){
    print(error);
  }
}


Future SignupUser({
  required String firstname,
  required String lastname,
  required String id,
  required String email,
  required String phone,
  required String gender,
  required String password,
  required String imageName,
  required base64Image,
})  async {
  try{
    String uri = "http://10.0.2.2:3000/users/signup";

    http.Response res = await http.post(Uri.parse(uri),
      body: jsonEncode({
        'id':id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'gender': gender,
        'password': password,
        'imageName':imageName,
        'base64Image':base64Image,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return jsonDecode(res.body);

  } catch(e){
    print(e);
    return {};
  }
}

Future updateUserPassword({
  required String id,
  required String password,
  required String newPassword
}) async{
  try{
    http.Response response =  await http.post(
        Uri.parse("http://10.0.2.2:3000/users/$id/password/update"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'password': password,
          'newPassword': newPassword
        })
    );

    print(response.statusCode);

    return response.statusCode == 200;
  }catch(error){
    return false;
  }
}

Future<String> getUserToken({required id}) async{
  var uri = "http://10.0.2.2:3000/users/$id/token";

  try{
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : "";
  }catch(err){
    print(err);
    return "";
  }
}


//void send
Future<bool> updateUserData({required String id,required String fn,required String ln,required String email,required String phone, required String? base64Image, required filename}) async{
  try{
    String uri = "http://10.0.2.2:3000/users/edit";

    http.Response response = await http.put(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id':id,
        'firstName':fn,
        'lastName':ln,
        'email':email,
        'phone':phone,
        'image64':base64Image,
        'imageName':filename
      })
    );

    return response.statusCode == 301;
  }catch(e){
    print(e);
    return false;
  }
}

Future<Map<dynamic,dynamic>> getUserData(String id) async{
  try{

    String uri = "http://10.0.2.2:3000/users/$id";
    http.Response response = await http.get(Uri.parse(uri),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'id':"$id"
      }
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : {};
  }catch(e){
    print(e);
    return {};
  }
}

Future<UserType> determineUserType(String id) async{
  try{

    String uri = "http://10.0.2.2:3000/api/userType/$id";
    http.Response response = await http.get(Uri.parse(uri),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body) == "user" ? UserType.NORMAL : UserType.CENTRE;
    }else{
      return UserType.UNKNOWN;
    }
  }catch(e){
    print(e);
    return UserType.UNKNOWN;
  }
}


Future<List> getUserReports(String id) async{
  try{

    String uri = "http://10.0.2.2:3000/users/$id/reports";
    http.Response response = await http.get(
        Uri.parse(uri),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    return response.statusCode == 200? List.from(jsonDecode(response.body)) : [];
  }catch(e){
    print(e);
    return [];
  }
}

Future<List> getUserNotifications({required String id}) async{

  var uri = 'http://10.0.2.2:3000/users/$id/notifications';
  try{
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    print(response.statusCode);

    return response.statusCode == 200 ? List.from(jsonDecode(response.body)) : [];
  }catch(err){
    print(err);
    return [];
  }
}

Future<void> pushUserNotification({
  required String id,
  required String title,
  required String body
}) async{
  var uri = 'http://10.0.2.2:3000/users/$id/notifications';
  try{
    http.Response response = await http.post(
        Uri.parse(uri),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: jsonEncode({
        'title':title,
        'body':body,
        'date':DateTime.now().millisecondsSinceEpoch
      })
    );
  }catch(err){

  }
}

Future<void> deleteUserNotification(String notificationId) async{
  var uri = "http://10.0.2.2:3000/users/notifications/$notificationId";
  try{
    await http.delete(
      Uri.parse(uri),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }catch(err){
    print(err);
  }
}