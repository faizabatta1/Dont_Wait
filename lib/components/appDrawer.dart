import 'package:dont_wait/Signup/Profile_page.dart';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/home_screen.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AboutUs.dart';
import '../Auth.dart';
import '../Book.dart';
import '../ChangePassword.dart';
import '../services/AuthChangeNotifier.dart';
import 'Edit_profile.dart';

class AppDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  AppDrawer({Key? key, required this.scaffoldKey}) : super(key: key);
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;


  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthChangeNotifier>(context,listen: false).userData;
    return Drawer(
      child: Container(
        decoration:BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 1.0],
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.0),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.0),
                ]
            )
        ) ,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors:
                    [ Theme.of(context).primaryColor,Theme.of(context).colorScheme.secondary],
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Text("Welcome ${userData['firstname']} ${userData['lastname']}",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25
                        ),)
                        ,
                    ),
                    Container(
                      child: IconButton(
                          onPressed: (){
                            scaffoldKey.currentState!.closeDrawer();
                          }, icon: Icon(Icons.close_fullscreen,size: 40,color: Colors.white,)
                      ),
                      alignment: Alignment.topRight,
                    )
                  ],
                )
            ),

            ListTile(
              leading: Icon(Icons.person_outline, size: _drawerIconSize, color:
              Theme.of(context).colorScheme.secondary,),
              title: const Text('My Profile', style: TextStyle(fontSize: 17, color: Colors.teal),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),ListTile(
              leading: Icon(Icons.home_outlined, size: _drawerIconSize, color:
              Theme.of(context).colorScheme.secondary,),
              title: const Text('Home Page', style: TextStyle(fontSize: 17, color: Colors.teal),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.mode_edit_outline_outlined,size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary),
              title: Text('Edite Page', style: TextStyle(fontSize: _drawerFontSize, color: Colors.teal),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()),);
              },
            ),
            ListTile(
              leading: Icon(Icons.password_outlined,size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary),
              title: Text('Change Password', style: TextStyle(fontSize: _drawerFontSize, color: Colors.teal),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()),);
              },
            ),
            Divider(color: Theme.of(context).primaryColor, height: 1,),
            ListTile(
              leading: Icon(Icons.bookmark_add_outlined, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary),
              title: Text('Book your appointment',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Book()),);
              },
            ),
            Divider(color: Theme.of(context).primaryColor, height: 1,),
            ListTile(
              leading: Icon(Icons.local_police_outlined, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary),
              title: Text('Licence',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
              onTap: () async {
                showAboutDialog(
                    context: context,
                  applicationLegalese: 'Copyright © Batta, 2023',
                  children: const <Widget>[
                  ],
                  applicationIcon: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(
                      image: AssetImage("assets/image/logo.png"),
                    ),
                  ),
                );
              },
            ),
            Divider(color: Theme.of(context).primaryColor, height: 1,),
            ListTile(
              leading: Icon(Icons.info_outline, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary),
              title: Text('About Us',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()),);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
              title: Text('Logout',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
              onTap: () async{
                final provider = Provider.of<AuthChangeNotifier>(context,listen: false);
                if(provider.userType == UserType.NORMAL){
                  //only user remove his token
                  await removeUserToken(id: Provider.of<AuthChangeNotifier>(context,listen: false).userData['id']).then((value) async {
                    //maybe it's not neccessary to change user type at logout because anyways login leads to login page
                    // Provider.of<AuthChangeNotifier>(context,listen: false).setUserType(UserType.UNKNOWN);
                    Provider.of<AuthChangeNotifier>(context,listen: false).setUserData({});
                    Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(false);
                  });
                }else{
                  //logged has only NORMAL AND CENTRE
                  Provider.of<AuthChangeNotifier>(context,listen: false).setUserData({});
                  Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(false);
                }
                SharedPreferences sp = await SharedPreferences.getInstance();
                await sp.setBool('logged', false);
                await sp.setString('userData', '{}');
                await sp.setString('id', '');

                await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Auth()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
