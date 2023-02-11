import 'dart:convert';
import 'package:dont_wait/CentreFeedbacks.dart';
import 'package:dont_wait/centreBranches.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dont_wait/header_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'ChatScreen.dart';
import 'Signup/ThemeHelper.dart';
import 'components/appDrawer.dart';
import 'home_screen.dart';


class CentreProfile extends StatefulWidget{
  final Map<dynamic,dynamic> centre;

  CentreProfile({required this.centre});

  @override
  State<CentreProfile> createState() => _CentreProfileState();
}

class _CentreProfileState extends State<CentreProfile> {
  final double  _drawerIconSize = 24;

  final double _drawerFontSize = 17;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      floatingActionButton: FloatingActionButton(
        /*
        * user and centre both have uid
        * collection rooms will have identifier as publisherUid-subscriberUid and not bi-directional
        * */
        onPressed: ()async {
          String publisher = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];

          Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context){
                return ChatScreen(
                    subscriber:widget.centre['id'],
                    publisher: publisher,
                    subscriber_name:widget.centre['placename']
                );
                return HomeScreen();
              })
          );
        },
        child: Icon(Icons.message,color: Colors.white,),
        backgroundColor: Colors.blueAccent,
      ),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('',
            style: TextStyle(
                fontSize:16,
                fontFamily: 'ultra')),


        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()));
          },
        ),

        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary,]
              )
          ),
        ),
        actions: [
          IconButton(
            onPressed: ()async{
              Map location = jsonDecode(widget.centre['location']);

              final availableMaps = await MapLauncher.installedMaps;
              print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

              await availableMaps.first.showMarker(
                coords: Coords(location['latitude'], location['longitude']),
                title: "Ocean Beach",
              );
            },
            icon: Icon(Icons.location_on,size: 40,),
          )
        ],
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey,),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [

                  const Text('', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                 // const Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 5, color: Colors.white),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(5, 5),),
                            ],
                          ),
                          child: Image.network(widget.centre['image']),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBarIndicator(
                                rating: double.parse(widget.centre['rating_score'].toString()),
                                itemCount: 5,
                                itemSize: 50,
                                itemBuilder:(context,index){
                                  return Icon(Icons.star,color: Colors.yellow,size: 35,);
                                }
                              ),
                              Text(double.parse(widget.centre['rating_score'].toString()).toStringAsFixed(2),style: TextStyle(fontSize: 20),),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Centre Information",style: const TextStyle(fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          leading: Icon(Icons.verified_user,color: Colors.teal,),
                                          title: Text("Centre Name :" ,style: const TextStyle(fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text(widget.centre['placename'],style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email,color: Colors.teal,),
                                          title: Text("Email :",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text(widget.centre['email'],style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email,color: Colors.teal,),
                                          title: Text("about :",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text("${widget.centre['description']}",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.phone,color: Colors.teal,),
                                          title: Text("Phone :" ,style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text("${widget.centre['phone']}",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.location_on,color: Colors.white,),
                                          title: Text("location :" ,style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text("${jsonDecode(widget.centre['location'])['place']}",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.medical_services,color: Colors.teal,),
                                          title: Text("MedicalTests",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text(widget.centre['medicalTests'].toString(),style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.location_city,color: Colors.teal,),
                                          title: Text("branches",style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                          subtitle: Text(widget.centre['branches'].toString(),style: const TextStyle(fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),

                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text('book'.toUpperCase(), style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'ultra',
                                  color: Colors.white),),
                            ),
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => CentreBranches(current_cenre: widget.centre)));
                            },
                          )
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: ()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => CentreFeedbacks(centre: widget.centre)));
                      },
                      child: Text("see patient feedbacks.")
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}