import 'dart:convert';
import 'dart:io';

import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:flutter/material.dart';
import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/header_widget.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/UserServices.dart';
import 'package:image/image.dart' as img;

class RegistrationPage extends  StatefulWidget{
  const RegistrationPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late File file;
  late String image_url;
  var path;
  var bytes;
  late img.Image image;

  var isUploaded = false;


  Future<void> openStudio() async{
    file = File((await ImagePicker.platform.getImage(source: ImageSource.gallery))!.path);

    setState((){
      isUploaded = true;
    });
  }

  Future<dynamic> getImageBase64() async{
    String base64Image = base64Encode(await file.readAsBytes());
    return base64Image;
  }

  Future<String> getFilename() async{
    String fileName = file.path.split('/').last;
    return fileName;
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    idController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String? gender;
  late String birthDateInString;
  late DateTime birthDate;

  void redirectToLoginPage(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Auth()
        ),
            (Route<dynamic> route) => false
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            GestureDetector(
              child: const SizedBox(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            controller: firstnameController,
                            decoration: ThemeHelper().textInputDecoration('First Name', 'Enter your first name'),
                            validator: (firstname){
                              if(firstname!.isEmpty && firstname.length >= 8){
                                return "firstname is too short";
                              }else{
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: lastnameController,
                            decoration: ThemeHelper().textInputDecoration('Last Name', 'Enter your last name'),
                            validator: (lastname){
                              if(lastname!.isEmpty && lastname.length >= 8){
                                return "lastname is too short";
                              }else{
                                return null;
                              }
                            }
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: idController,
                           // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]$|^10$'),),],
                            decoration: ThemeHelper().textInputDecoration('id', 'Enter your id'),
                            validator: (field){
                              if(field!.isEmpty ){
                                return "please enter an id";
                              }else if(field.length < 10){
                                return "your id is very short";
                              }else{
                                return null;
                              }
                            }
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration('email', 'Enter your email'),
                            validator: (field){
                              if(field!.isEmpty){
                                return "enter an email";
                              }else{
                                return null;
                              }
                            }
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
                            validator: (val){
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),


                        const SizedBox(height: 15.0),

                        Container(

                          child: Column(
                            children: [


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Row(
                                    children: [

                                      Radio(value: "male", groupValue: 'gender', onChanged : (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      }),
                                      const Text('Male')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(value: "female", groupValue: 'gender', onChanged: (value) {
                                        gender = value;
                                      }),
                                      const Text('Female')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

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
                                "finish".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async{
                              var base64Image = await getImageBase64();
                              var imageName = await getFilename();

                              if(_formKey.currentState!.validate()){
                                await SignupUser(
                                    id:idController.text,
                                    firstname: firstnameController.text,
                                    lastname: lastnameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    gender: gender!,
                                    password: passwordController.text,
                                    imageName:imageName,
                                    base64Image:base64Image
                                ).then((status){
                                  if(status['success']){
                                    redirectToLoginPage();
                                  }else{
                                    Utils.showSnackbar(context: context, message: status['message']);
                                  }
                                });
                              }else{
                                Utils.showSnackbar(context: context, message: "form is not complete");
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