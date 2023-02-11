import 'package:badges/badges.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tab/Diseases.dart';
import '../../tab/Medical_Analysis.dart';
import '../../tab/Medical_Guidelines.dart';
import '../../tab/NewsArticles.dart';
import 'package:flutter/services.dart';
import 'CHAT.dart';
import 'Notifications.dart';
import 'components/MyTab.dart';
import 'components/appDrawer.dart';
import 'components/serch.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO.txt: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  List<Widget> myTabs = const [

    MyTab(
      iconPath: 'assets/icon/icons8-us-news-100.png',

    ),

    MyTab(
      iconPath: 'assets/icon/icons8-allergy-100 (1).png',

    ),


    MyTab(
      iconPath: 'assets/icon/icons8-medical-100.png',

    ),


    MyTab(
      iconPath: 'assets/icon/icons8-guidelines-100.png',

    ),


  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(

      length: myTabs.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),

        drawer: AppDrawer(scaffoldKey:_scaffoldKey),

        body:Column(
          children: [
            const Text(
              "Hello all,\n    be safe "
                 // ",${Provider.of<AuthChangeNotifier>(context,listen: false).userData!['firstname']}"
                  ,
              style:TextStyle(
                fontSize: 30,
                fontFamily: 'ultra',
                shadows: [
                  Shadow(
                      color: Colors.teal,
                      offset: Offset(10, 20))
                ],
                color: Colors.transparent,

              ),
            ),
            SearchBar(),
            // ElevatedButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStatePropertyAll(Colors.teal)
            //   ),
            //     onPressed: () async{
            //
            //     },
            //     child: Text("test feauture",style: TextStyle(color: Colors.white),)
            // ),
            TabBar(tabs: myTabs),
            Expanded(
              child: TabBarView(
                // controller: tabController,

                children: [

                  News(),
                  //
                  //
                  Diseases(),
                  //
                  //
                  Medical_Analysis(),
                  //
                  //
                  Medical_Guidelines(),


                ],
              ),
            ),
          ],
        ),
        //bottomNavigationBar: MyBottomNavBar(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(

      backgroundColor: Colors.teal,

      leading: IconButton(
        icon: Icon(Icons.menu,color: Colors.white,size: 30,),
        onPressed: () async{
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      // On Android by default its false

      centerTitle: true,
      //title: Text("Home"),
      actions: <Widget>[
      StreamBuilder(
          stream: FirestoreService.firestore.collection("messages").snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData && !snapshot.hasError){
              String uid = Provider.of<AuthChangeNotifier>(context,listen:false).userData['id'];
              Set subscribers = Set();
              var publisherMessages = snapshot.data!.docs.where((element) => element['publisher'] == uid).toList();

              for(var message in publisherMessages){
                 subscribers.add(message['subscriber']);
              }

              List totalContacts = subscribers.toList();
              return Badge(
                child: IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return chat(subscriber: uid,);
                      }));
                    },
                    icon: Icon(Icons.chat_bubble ,color: Colors.white,size: 35,)
                ),
                badgeContent: Text("${totalContacts.length}",style: TextStyle(color: Colors.white),),
                badgeColor: Colors.red,
              );
            }else{
              return CircularProgressIndicator();
            }

      })
    ,
        SizedBox(
          // It means 5 because by out defaultSize = 10
          width: SizeConfig.defaultSize! * 0.5,
        ),
        IconButton(
          icon :Image.asset("assets/icon/notificationt.png" ,color: Colors.white)  ,
          onPressed: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
          },

        ),
        SizedBox(
          // It means 5 because by out defaultSize = 10
          width: SizeConfig.defaultSize! * 0.5,
        )
      ],

    );

  }
}