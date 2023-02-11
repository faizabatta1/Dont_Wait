
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'Book.dart';
import 'Signup/ThemeHelper.dart';
import 'Date.dart';


class MultiSelect extends StatefulWidget {
  final List items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final VideoPlayerController videoPlayerController =
  VideoPlayerController.asset("assets/image/sas.mp4");

  ChewieController? chewieController;

  // init State
  @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 20,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      showControls: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }
  // this variable holds the selected items
  String? _selectedItem = "";

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue) {
    print(itemValue);
    setState(() {
      _selectedItem = itemValue;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItem);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          //TODO.txt:change checkbox to radio to limit test choices
          children: widget.items
              .map((item) => RadioListTile(
            value: item,
               groupValue: "the same value for all items",
          //  tileColor: Colors.red,
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
             onChanged: (value) => _itemChange(value!),

          )
            ,

          )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// Implement a multi select on the Home screen
class Tests extends StatefulWidget {
  final List medicalTests;
  final String centreId;
  const Tests({Key? key, required this.medicalTests, required this.centreId}) : super(key: key);

  @override
  State<Tests> createState() => _HomePageState();
}

class _HomePageState extends State<Tests> {
  String _selectedItems = "";

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List items = widget.medicalTests;

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () { /* Write listener code here */ },
            child: IconButton(
              icon : Icon(
                Icons.arrow_back,
                size: 26.0,color: Colors.white,
              ),

              onPressed: (){
                  Navigator.pop(context);
                },

            ),
          ),

        ),

      body: Padding(

        padding: const EdgeInsets.all(40),
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // use this button to open the multi-select dialog
            ElevatedButton(
              onPressed: _showMultiSelect,
              child: const Text(
                "Choose the types of medical tests need to do:",
                style: TextStyle(
                  fontSize: 22.5,
                  fontFamily: 'ultra',
                  shadows: [
                    Shadow(
                        color: Colors.teal,
                        offset: Offset(0, -5))
                  ],
                  color: Colors.white,

                ),
              ),

            ),

            const Divider(
              height: 40,
            ),
            // display selected items
            Chip(label: _selectedItems != "" ? Text(_selectedItems) : Container()),
            const SizedBox(height: 300),
            Container(

              decoration: ThemeHelper().buttonBoxDecoration(context),
              child: ElevatedButton(
                style: ThemeHelper().buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text('Next'.toUpperCase(), style: const TextStyle(fontSize: 20,fontFamily: 'ultra' , color: Colors.white),),
                ),
                onPressed: (){
                  //After successful login we will redirect to profile page. Let's create profile page now
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DateAndTime(centreId:widget.centreId,test:_selectedItems,)));
                },
              ),
            )

          ],

        ),


      ),

    );
  }
}