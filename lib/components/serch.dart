

import 'package:dont_wait/centreProfile.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';

import '../services/FirestoreService.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late Future<List<Map<dynamic,dynamic>>> centres;

  @override
  void initState() {
    super.initState();
    centres = getCentres();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: centres,
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData && !snapshot.hasError){
          List<Map>? data = snapshot.data;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(29.5),
            ),
            child: TextField(
              readOnly: true,
                onTap: ()async{
                  await showSearch(context: context, delegate: CentreSearch(centres:data!),query: "");
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  icon: Image.asset("assets/icon/magnifying-glass (1).png"),
                  border: InputBorder.none,
                )),
          );
        }else{
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class CentreSearch extends SearchDelegate<String>{
  List<Map> centres;
  CentreSearch({required this.centres});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear), onPressed: () {
          query = "";
      },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
    onPressed: (){
      close(context, "");
    },
    icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: const Text(""),);
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white70,
      child: ListView.builder(
        itemCount: centres.length,
        itemBuilder: (context,index){
          String placename = centres[index]['placename'];
          List branches = (centres[index]['branches'] as String).split((','));
          List tests = (centres[index]['medicalTests'] as String).split((','));
          return  placename.toLowerCase().contains(query.toLowerCase())
              || branches.any((element) => (element as String).trim().toLowerCase().contains(query.toLowerCase()))
              || tests.any((element) => (element as String).trim().toLowerCase().contains(query.toLowerCase())) ?
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CentreProfile(centre: centres[index],)));
            },
         child : Container(
           margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal,
          ),
          child: Center(child: Text(placename,style: const TextStyle(fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: Colors.white))),
          ),

          ) : Container(height:0);
        },
      ),
    );
  }

}