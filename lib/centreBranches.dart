import 'package:dont_wait/centreProfile.dart';
import 'package:dont_wait/services/CentreChangeNotifier.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Book.dart';
import 'Tests.dart';
import 'home_screen.dart';

class CentreBranches extends StatefulWidget {
  final Map<dynamic,dynamic> current_cenre;
  const CentreBranches({Key? key, required this.current_cenre}) : super(key: key);

  @override
  State<CentreBranches> createState() => _CentreBranchesState();
}

class _CentreBranchesState extends State<CentreBranches> {

  @override
  Widget build(BuildContext context) {
    List branches = widget.current_cenre['branches'].split(',');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'Choose branch:',
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(110),
        child: GridView.builder(
            itemCount: branches.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisSpacing: 5, crossAxisSpacing: 2),
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () async{
                  List tests = (widget.current_cenre['medicalTests'] as String).split(',');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return ChangeNotifierProvider(
                          create: (_) => CentreChangeNotifier(current_centre: widget.current_cenre),
                          child: Tests(medicalTests: tests, centreId: widget.current_cenre['id']),
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
                      color: Colors.teal
                  ),
                  child: Text(branches[i],style: TextStyle(fontSize: 10,fontFamily: 'ultra',
                    color: Colors.white, ),

                  ),
                ),
              );
            }),
      ),
    );
  }
}
