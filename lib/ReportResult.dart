import 'dart:convert';
import 'dart:io';

import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:dont_wait/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Signup/ThemeHelper.dart';

class ReportResult extends StatefulWidget {
  final Map test;
  const ReportResult({Key? key, required this.test}) : super(key: key);

  @override
  State<ReportResult> createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult> {
  FocusNode focusNode = FocusNode();
  TextEditingController resultController = TextEditingController();
  bool uploaded_report = false;

  File? file;

  Future<void> openStudio() async{
    file = File((await ImagePicker.platform.getImage(source: ImageSource.gallery))!.path);
  }

  Future<String> getImageBase64() async{
    String base64Image = base64Encode(await file!.readAsBytes());
    return base64Image;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: GestureDetector(
        onTap: (){
          focusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !uploaded_report && file == null ? TextFormField(

                    focusNode: focusNode,
                    controller: resultController,
                    maxLines: 10,
                    decoration: InputDecoration(

                        border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: "write patient test result",
                        label: Text("result",style:TextStyle(
                          fontSize: 15,
                          fontFamily: 'ultra',
                          color: Colors.teal,

                        ),)
                    ),
                  ) : Image.file(file!),
                  SizedBox(height: 20,),
                  ElevatedButton(
               style: ThemeHelper().buttonStyle(),
                    onPressed: ()async{
                      if(resultController.text.isNotEmpty || file != null){
                        await pushReport(
                            patient_name: widget.test['patient_name'],
                            centre_name:widget.test['centre_name'],
                            test_type: widget.test['test'],
                            result: file != null ? (await getImageBase64()) : resultController.text,
                            date:widget.test['date'],
                            patient_id:widget.test['patientId'],
                            result_type: file != null ? 'image' : 'text',
                            status: 'done',
                            centre_id: widget.test['centreId']
                        ).then((value) async{
                          await deleteAppointment(id: widget.test['id'].toString()).then((value){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => table()));
                          });
                        });
                      }else{
                        Utils.showSnackbar(context: context, message: "report is empty");
                      }
                    },
                    child: Text('submit'.toUpperCase(),style:TextStyle(
                      fontSize: 16,
                      fontFamily: 'ultra',
                      color: Colors.white,

                    ),),
                  ),
                  TextButton(
                      onPressed: ()async{
                        await openStudio().then((_){
                          setState(() {
                            uploaded_report = true;
                          });
                        });
                      },
                      child: Text('upload report instead?')
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
