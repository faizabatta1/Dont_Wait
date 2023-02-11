import 'dart:convert';
import 'dart:io';

import 'package:dont_wait/Signup/Profile_page.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/Storage.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Signup/ThemeHelper.dart';
import '../header_widget.dart';
import '../home_screen.dart';
//import 'package:settings_ui/pages/settings.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String? gender;
  late String birthDateInString;
  late DateTime birthDate;
  bool isUploaded = false;

  File? file;
  void openStudio() async {
    file = File(
        (await ImagePicker.platform.getImage(source: ImageSource.gallery))!
            .path);
    setState(() {
      isUploaded = true;
    });
  }

  Future<String> getFilename() async {
    if(file != null){
      return file!.path.split('/').last;
    }else{
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map user = Provider.of<AuthChangeNotifier>(context,listen: false).userData;
    firstNameController.text = user['firstname'];
    lastNameController.text = user['lastname'];
    phoneController.text = user['phone'];


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:
            const Text('', style: TextStyle(fontSize: 16, fontFamily: 'ultra')),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 150,
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
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: isUploaded
                                    ? Image.file(file!)
                                    : InkWell(
                                        child: Image.network(user['image']),
                                        onTap: () {
                                          openStudio();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'First Name', 'Enter your first name'),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Last Name', 'Enter your last name'),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: phoneController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 40,
                            width: 190,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                    backgroundColor: Colors.teal,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 2.2,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel', style: TextStyle(fontSize: 16, fontFamily: 'ultra',  color: Colors.white),),
                                )),
                      SizedBox(height: 30,)
                      ,
                      SizedBox(
                        height: 40,
                        width: 190,
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 50),
                            backgroundColor: Colors.teal,
                            elevation: 2,
                            shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(20)),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 2.2,
                                fontSize: 14,
                                fontStyle: FontStyle.normal),
                          ),
                          onPressed: () async {
                            print(user);
                            var imageName = await getFilename(); // or ""
                            await updateUserData(
                                fn: firstNameController.text,
                                ln: lastNameController.text,
                                email: '', // empty because it won't change
                                phone: phoneController.text,
                                base64Image: file != null ? base64Encode(file!.readAsBytesSync()) : null, // or null
                                filename: imageName,
                                id: user['id']
                            ).then((value) async{
                              if(value){
                                var updatedData = await getUserData(user['id']);
                                Provider.of<AuthChangeNotifier>(context,listen: false).setUserData(updatedData);

                                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                              }else{
                                Utils.showSnackbar(context: context, message: "not updated");
                              }
                            });
                          },
                          child: const Text('Save', style: TextStyle(fontSize: 16, fontFamily: 'ultra',  color: Colors.white),),
                        ),
                      )
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
