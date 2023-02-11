import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List> getData({ required String url }) async{
  var data = [];
  try{
    http.Response response = await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    data = jsonDecode(response.body);
    return List.from(data);

  }catch(e){
    print(e);
    return data;
  }
}

