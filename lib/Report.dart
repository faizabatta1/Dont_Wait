import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dont_wait/UserFeedback.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

List<Color> _colors = [Colors.teal, Colors.white, Colors.teal];

class Report extends StatelessWidget {
  final Map<String,dynamic> reportData;

  Report({Key? key,required this.reportData}) : super(key: key);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("patient test report",style:TextStyle(
          fontSize: 20,
          fontFamily: 'ultra',
          color: Colors.white,

        ),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async{
                if (await Permission.storage.request().isGranted){
                  if(reportData['result_type'] == 'text'){
                    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                    await screenshotController.capture(
                        pixelRatio: pixelRatio,
                        delay: Duration(milliseconds: 10)
                    ).then((Uint8List? image) async{
                      if(image != null){
                        final result = await ImageGallerySaver.saveImage(
                            image,
                            quality: 60,
                            name: DateTime.now().millisecondsSinceEpoch.toString()
                        );
                      }
                    });
                  }else{
                    final result = await ImageGallerySaver.saveImage(
                      base64Decode(reportData['result']),
                      quality: 60,
                      name: DateTime.now().millisecondsSinceEpoch.toString()
                    );
                  }
                }
              },
              icon: Icon(Icons.download,color: Colors.white,size: 30,)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    // Text(
                    //   'please give us a feedback so we can do better.',
                    //   style: TextStyle(
                    //       fontSize: 20
                    //   ),
                    // ),
                    TextButton(
                        onPressed: ()async{
                          await Navigator.push(context, MaterialPageRoute(builder: (context){
                            return UserFeedback(report:reportData);
                          }));
                        },
                        child: Text('Feedback',style: TextStyle(
                            fontSize: 20,
                          color: Colors.teal
                        ),)
                    )
                  ],
                ),
                Screenshot(
                  controller: screenshotController,
                  child: reportData['result_type'] == 'text' ? Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [

                            const SizedBox(height: 20,),

                            Container(
                              alignment: Alignment.center,

                              height: 600,
                              decoration:  BoxDecoration(

                                color: Colors.teal,
                                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 5)],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children:  <Widget>[
                                  SizedBox(height: 100,
                                    child: Card(

                                      borderOnForeground: true,
                                      shadowColor: Colors.teal,
                                      elevation: 7,
                                      child: ListTile(
                                        enabled: true,
                                        hoverColor: Colors.teal,
                                        selectedTileColor: Colors.cyan,
                                        horizontalTitleGap: 6.0,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                         title: Text( "Hello ${reportData['patient_name']} \n This is your ${reportData['test_type']}  result",style:TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'ultra',
                                          color: Colors.black,

                                        ),textAlign: TextAlign.center,),
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: 60,
                                    child: Card(

                                      borderOnForeground: true,
                                      shadowColor: Colors.teal,
                                      elevation: 7,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                        title: Text( " Date : ${reportData['date']} \n"
                                            "done in ${reportData['centre_name']}",style:TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'ultra',
                                          color: Colors.black,

                                        ),textAlign: TextAlign.center,),
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: 7,),
                                  SizedBox(height: 400,
                                      child: Card(
                                        borderOnForeground: true,
                                        shadowColor: Colors.teal,
                                        elevation: 7,
                                        child: ListTile(
                                          horizontalTitleGap: 6.0,

                                          title:
                                          Text( "${reportData['result']}",style: TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: Colors.black)),

                                        ),
                                      ))


                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ) : Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.memory(base64Decode(reportData['result'])).image,
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
