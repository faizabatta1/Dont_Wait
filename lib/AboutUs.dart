import 'package:flutter/material.dart';

import '../home_screen.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 26.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        title: Text("About Us",
          style: TextStyle(fontSize: 30, fontFamily: 'ultra',  color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            ClipOval(
              child:  Image.asset( "assets/image/logo.png", height: 200,width: 200 ,
              ), //put your logo here
            ),

            SizedBox(height: 20),
            const Card(
              child: ListTile(
                title: Text("Welcome to Don't Wait",
                  style: TextStyle(fontSize: 20, fontFamily: 'ultra',  color: Colors.teal), ),
                subtitle: Text("\nThis app aims to help people who suffer from waiting for the results of their medical analyzes for a long time inside the medical center or to return to take the medical analysis more than once, and also to help patients to make advance reservations, and help the elderly and others to make home reservations. The application also contains important health information."
                  ,
                  style: TextStyle(fontSize: 13, fontFamily: 'ultra',  color: Colors.grey),),
              ),
            ),

            const Card(
              child: ListTile(
                title: Text('Contact',
                  style: TextStyle(fontSize: 20, fontFamily: 'ultra',  color: Colors.teal),),
                subtitle: Text('dontwaitfir@gmail.com',
                  style: TextStyle(fontSize: 13, fontFamily: 'ultra',  color: Colors.grey),),

              ),
            ),
          ],
        ),
      ),
    );
  }
}