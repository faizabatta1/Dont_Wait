import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



Future<bool> signupCentre({ required Map<String,String> data,required List<String> medicalTests,required List<String> branches}) async{
  var uri = "http://10.0.2.2:3000/centres";
  try{
    http.Response res = await http.post(Uri.parse(uri),
      body: jsonEncode({
        'data':data,
        'medicalTests':medicalTests,
        'branches': branches
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return res.statusCode == 201;
  }catch(e){
    print(e);
    return false;
  }
}

Future<Map> getCentre(String id) async{
  var uri = "http://10.0.2.2:3000/centres/$id";
  try{
    http.Response response = await http.get(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : {};
  }catch(e){
    print(e);
    return {};
  }
}

Future<List<Map<dynamic,dynamic>>> getCentres() async{
  var uri = "http://10.0.2.2:3000/centres";
  try{
    http.Response response = await http.get(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(List.from(jsonDecode(response.body)));
    return response.statusCode == 200 ? List.from(jsonDecode(response.body)) : [];
  }catch(e){
    print(e);
    return [];
  }
}

Future<List> getAllCentreAppointments(String id) async{
  try{
    var uri = "http://10.0.2.2:3000/centres/${id}/reservations";
    http.Response response = await http.get(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response.statusCode == 200 ? List.from(jsonDecode(response.body)) : [];
  }catch(e){
    print(e);
    return [];
  }
}

Future<String> getCurrentCentreName({String? optId}) async{
  var uri;
  if(optId != null){
    uri = "http://10.0.2.2:3000/centres/$optId";
  }else{

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? id = sp.getString('id');

    uri = "http://10.0.2.2:3000/centres/$id";
  }

  http.Response response = await http.get(Uri.parse(uri),headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });
  Map body = jsonDecode(response.body);
  return response.statusCode == 200 ? body['placename'] : "unknown";
}

Future<Map> loginCentre({required String id,required String password}) async{
  var uri = "http://10.0.2.2:3000/centres/auth/login";
  try{
    http.Response res = await http.post(Uri.parse(uri),
      body: jsonEncode({
        'id':id,
        'password': password
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(res.statusCode == 200){
      return jsonDecode(res.body);
    }else{
      return {};
    }
  }catch(e){
    print(e);
    return {};
  }
}

Future<Map> bookAppointment({
  required String centreId
  ,required String date
  ,required String time
  ,required String typeOfTests
  ,required String userId, required String centre_name, required String patient_name
}) async{
  String uri = "http://10.0.2.2:3000/centres/reservations";

  try{
    http.Response response = await http.post(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId':userId,
        'centreId':centreId,
        'date':date,
        'time':time,
        'typeOfTests':typeOfTests,
        'centre_name':centre_name,
        'patient_name':patient_name
      })
    );

    return jsonDecode(response.body);
  }catch(e){
    print(e);
    return {
      'success':false,
      'message':"internal flutter error"
    };
  }
}

Future<List<dynamic>> getAllUserAppointments(String userId) async{
  try{
    http.Response response = await http.get(Uri.parse("http://10.0.2.2:3000/users/$userId/reservations"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
    );

    return List.from(jsonDecode(response.body));
  }catch(e){
    print(e);
    return [];
  }
}

Future<List> getCentreTests(String centreId) async{
  var centres = await getCentres();
  var items = centres.where((element) => element['id'] == centreId).toList();
  if(items.length > 0){
    return (items.first['medicalTests'] as String).split(',');
  }
  return [];
}

Future<bool> updateAppointmentStatus({required String id,required String newStatus}) async{
  try{
    http.Response response = await http.post(Uri.parse("http://10.0.2.2:3000/centres/reservations/$id/status/update"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'newStatus':newStatus
        })
    );

    return response.statusCode == 200;
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> updateAppointment({required Map data}) async{
  try{
    http.Response response = await http.put(Uri.parse("http://10.0.2.2:3000/centres/reservations"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'data':data
      })
    );

    return response.statusCode == 200;
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> deleteAppointment({required id}) async{
  try{
    http.Response response = await http.delete(Uri.parse("http://10.0.2.2:3000/centres/reservations"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'id':id
      })
    );

    return response.statusCode == 200;
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> pushReport({
  required String patient_name,
  required String test_type,
  required String status,
  required String result,
  required String date,
  required String patient_id,
  required String centre_id,
  required String centre_name,
  required String result_type
}) async{
  try{
    http.Response response = await http.post(Uri.parse("http://10.0.2.2:3000/centres/reports"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'patient_name':patient_name,
          'test_type':test_type,
          'date':date,
          'result':result,
          'status':status,
          'patient_id':patient_id,
          'centre_name':centre_name,
          'result_type':result_type,
          'centre_id':centre_id
        })
    );

    return response.statusCode == 201;
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> pushFeedback({
  required String patient_name,
  required double rating,
  required String comment,
  required String patient_id,
  required String centre_id,
  required String centre_name,
}) async{
  try{
    http.Response response = await http.post(Uri.parse("http://10.0.2.2:3000/centres/feedbacks"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'patient_name':patient_name,
          'rating':rating,
          'comment':comment,
          'patient_id':patient_id,
          'centre_name':centre_name,
          'centre_id':centre_id
        })
    );

    return response.statusCode == 201;
  }catch(e){
    print(e);
    return false;
  }
}

Future<List> getFeedbacks({required centreId}) async{
  var uri = 'http://10.0.2.2:3000/centres/$centreId/feedbacks';
  try{
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    return List.from(jsonDecode(response.body));
  }catch(err){
    print(err);
    return [];
  }
}


Future addCentreToCheckPoint(Map data) async{
  var uri = "http://10.0.2.2:3000/admin/checkpoint";

  try{
    http.Response response = await http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'data':data
      })
    );
  }catch(err){
    print(err);
  }
}