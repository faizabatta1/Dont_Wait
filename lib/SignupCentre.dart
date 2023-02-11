
import 'dart:convert';
import 'dart:io';

import 'package:dont_wait/selectit.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/Storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/header_widget.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
//import 'profile_page.dart';


class CentreRegistration extends  StatefulWidget{
  // final String uid;
  // const CentreRegistration({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<CentreRegistration>{

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String? gender;
  late String birthDateInString;
  late DateTime birthDate;

  final placenameController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  late File file;
  late String image_url;
  var isUploaded = false;

  Future<void> openStudio() async{
    file = File((await ImagePicker.platform.getImage(source: ImageSource.gallery))!.path);

    setState((){
      isUploaded = true;
    });
  }

  Future<String> getFilename() async{
    String fileName = file.path.split('/').last;
    return fileName;
  }

  var openTime = TextEditingController();
  var closeTime = TextEditingController();







  @override
  Widget build(BuildContext context) {
    bool? check2 = true;
    bool like;
    List<Modal> userList = <Modal>[];

    @override
    void initState() {
      userList.add(Modal(name: 'Dipto', isSelected: false));
      userList.add(Modal(name: 'Dipankar', isSelected: false));
      userList.add(Modal(name: 'Sajib', isSelected: false));
      userList.add(Modal(name: 'Shanto', isSelected: false));
      userList.add(Modal(name: 'Pranto', isSelected: false));
      super.initState();
    }
    return Scaffold(

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [


            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(isUploaded ? 20 : 100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: isUploaded ?
                                Image.file(File(file.path)):IconButton(
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade300,
                                    size: 60.0,
                                  ),
                                  onPressed: () async{
                                    await openStudio();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: idController,
                            decoration: ThemeHelper().textInputDecoration('id', 'Enter your id'),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: placenameController,
                            decoration: ThemeHelper().textInputDecoration('placename', 'Enter your placenaem'),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration('email', 'Enter your emal'),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: ThemeHelper().textInputDecoration('description', 'Enter your centre description'),
                          ),
                        ),
                        // SizedBox(height: 30,),
                        // Container(
                        //   child: TextFormField(
                        //     decoration: ThemeHelper().textInputDecoration('Last Name', 'Enter your last name'),
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),

                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: openTime,
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 11, minute: 00)
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  openTime.text = "${pickedTime.hour}-${pickedTime.minute}"; //set output date to TextField value.
                                });
                              } else {}
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                "open Time", "Open Time"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Open Time??";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: closeTime,
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 11, minute: 00)
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  closeTime.text = "${pickedTime.hour}-${pickedTime.minute}"; //set output date to TextField value.
                                });
                              } else {}
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                "Close Time", "Close Time"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Close Time??";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: phoneController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number",
                                "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "next".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                // User user = Authentication.auth.currentUser!;
                                // AuthCredential credentials = EmailAuthProvider.credential(
                                //     email: user.email!,
                                //     password: passwordController.text
                                // );

                                try{

                                  var image_name = await getFilename();
                                  Map<String,dynamic> data = {
                                    'placename':placenameController.text,
                                    'id':idController.text,
                                    'email':emailController.text,
                                    'description':descriptionController.text,
                                    'password':passwordController.text,
                                    'phone':phoneController.text,
                                    'open_time':openTime.text,
                                    'close_time':closeTime.text,
                                    'base64Image':base64Encode(file.readAsBytesSync()),
                                    'image_name':image_name,
                                  };

                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>iss(data: data,)
                                      )
                                  );
                                } on FirebaseAuthException catch(error){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${error.message}"))
                                  );

                                  return;
                                }
                              }
                            },
                          ),

                        ),
                        const SizedBox(height: 30.0),
                        //Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [

                            SizedBox(width: 30.0,),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class Modal {
  String name;
  bool isSelected;

  Modal({required this.name, this.isSelected = false});
}
_iconControl(bool like) {
  if (like == false) {
    return const Icon(Icons.favorite_border);
  } else {
    return const Icon(
      Icons.favorite,
      color: Colors.red,
    );
  }
}