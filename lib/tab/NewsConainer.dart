import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';



class NewsContainer extends StatelessWidget {
  final Map<String,dynamic> currentNews;
  const NewsContainer({Key? key, required this.currentNews,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10),

      child: ListView(

        children: [
          SizedBox(


           child: Text(currentNews['name'],textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black,),
           ),),

          SizedBox(height: 10,),
          Text(currentNews['date'],style: const TextStyle(fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic, fontSize: 10,fontFamily: 'ultra' ,color: Colors.black)),
          Text(currentNews['author'],style: const TextStyle(fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic, fontSize: 10,fontFamily: 'ultra' ,color: Colors.black)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.black, Colors.teal],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft
                  ),
                    image: DecorationImage(
                        image: NetworkImage(currentNews['image']),
                      fit: BoxFit.fill,
                    ),
                  border: Border.all(
                    width: 5,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Text(currentNews['newsContant'].toString().split(' ').sublist(0,(currentNews['newsContant'].toString().split(" ").length / 2).round() ).join(' '),style: const TextStyle(fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic, fontSize: 10,fontFamily: 'ultra' ,color: Colors.black),
              //textAlign: TextAlign.center
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 30,
            width: 10,

              child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.teal,
                    shadowColor: Colors.teal[700],
                    elevation: 7,
                   // shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                  ),
                  onPressed: _launchUrl,
                  child: const Text("show more",style: const TextStyle(fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic, fontSize: 15,letterSpacing: .5,fontFamily: 'ultra' ,color: Colors.black))
              )
          )
        ],
      ),
    );
  }

 Future<void> _launchUrl() async{
    Uri _url = Uri.parse(currentNews['url']);
    if (await canLaunchUrl(_url)) {
      launchUrl(_url,mode: LaunchMode.platformDefault,webViewConfiguration: const WebViewConfiguration(),webOnlyWindowName: "news");
    }else{
      print("error");
      throw 'Could not launch $_url';
    }
  }
}
