import 'package:dont_wait/services/CentreChangeNotifier.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Book.dart';
import 'Tests.dart';
import 'home_screen.dart';

class BranchCentres extends StatefulWidget {
  final String city;
  const BranchCentres({Key? key, required this.city}) : super(key: key);

  @override
  State<BranchCentres> createState() => _CentreBranchesState();
}

class _CentreBranchesState extends State<BranchCentres> {
  late Future<List<Map>> centres;

  @override
  void initState() {
    super.initState();
    centres = getCentres();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'Choose Centre:',
          style:
              TextStyle(fontSize: 20, fontFamily: 'ultra', color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 26.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Book()));
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: centres,
        builder: (context,snapshot){
          if(snapshot.hasData && !snapshot.hasError){
            var data = snapshot.data!
                .where((element) => (element['branches'] as String).split(',').any((element) => element.trim().contains(widget.city)))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(110),
              child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, mainAxisSpacing: 5, crossAxisSpacing: 2),
                  itemBuilder: (BuildContext context, int i) {
                    return InkWell(
                      onTap: () async{
                        List tests = (data[i]['medicalTests'] as String).split(',');
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context){
                              return ChangeNotifierProvider(
                                create: (_) => CentreChangeNotifier(current_centre: data[i]),
                                child: Tests(medicalTests: tests, centreId: data[i]['id']),
                              );
                            })
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(data[i]['image'])
                          )
                        ),
                        child: Text(data[i]['placename'],style: TextStyle(fontSize: 10,fontFamily: 'ultra',
                          color: Colors.black, ),

                        ),
                      ),
                    );
                  }),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }
}
