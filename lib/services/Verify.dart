import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> createAndSendVerifyCode({required String email, required BuildContext context}) async{
  try{
    String create = "http://10.0.2.2:3000/login/verify/codes";
    String send = "http://10.0.2.2:3000/login/verify/send";

    http.Response createResponse =  await http.post(Uri.parse(create),
        body: jsonEncode({ 'email':email }),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );


    http.Response sendResponse = await http.get(Uri.parse(send),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'email': email
        }
    );

    if(createResponse.statusCode == 200 && sendResponse.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> compareCode({ required String code,required String email}) async{
  try{
    String compare = "http://10.0.2.2:3000/login/verify/compare";

    http.Response compareResponse =  await http.post(Uri.parse(compare),
        body: jsonEncode({ 'email':email, 'code':code }),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    if(compareResponse.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }catch(e){
    print(e);
    return false;
  }
}

Future<bool> resetPassword({ required String email,required String newPassword }) async{
  try{
    String resetApi = "http://10.0.2.2:3000/login/verify/reset";
    http.Response resetResponse = await http.post(Uri.parse(resetApi),
      body: jsonEncode({ 'email':email,'newPassword':newPassword }),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    return resetResponse.statusCode == 301;
  }catch(err){
    print(err);
    return false;
  }
}