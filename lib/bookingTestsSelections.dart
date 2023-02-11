import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'Signup/ThemeHelper.dart';
import 'Date.dart';

class Selections extends StatelessWidget {
  final Map<String,String> data;
  const Selections({Key? key,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'KindaCode.com',
      theme: ThemeData(
        // enable Material 3
        useMaterial3: true,
        primarySwatch: Colors.teal,
      ),
      home: HomePage(data: data,),
    );
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
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
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(

          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
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
class HomePage extends StatefulWidget {
  final Map<String, String> data;
  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'amniocentesis',
      'blood analysis',
      'blood count',
      'blood typing',
      'bone marrow aspiration',
      'cephalin-cholesterol flocculation',
      'enzyme analysis',
      'epinephrine tolerance test',
      'glucose tolerance test',
      'hematocrit',
      'immunologic blood test',
      'inulin clearance',
      'serological test',
      'thymol turbidity',
      'gastric fluid analysis',
      'kidney function test',
      'liver function test',
      'lumbar puncture',
      'malabsorption test',
      'Pap smear',
      'phenolsulfonphthalein test',
      'pregnancy test',
      'prenatal testing',
      'protein-bound iodine test',
      'syphilis test',
      'thoracentesis',
      'thyroid function test',
      'toxicology test',
      'urinalysis/uroscopy',
      'ballistocardiography',
    'electrocardiography',
      'electroencephalography',
      'electromyography',
      'lumbar puncture',
      'magnetic resonance spectroscopy',
      'phonocardiography',
      'pulmonary function test',
      'semen analysis',
    ];

    final List<String>? results = await showDialog(
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

      ),

      body: Padding(

        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(


            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // use this button to open the multi-select dialog
              ElevatedButton(
                onPressed: _showMultiSelect,
                // Text('Choose the types of medical tests you do'),
                child: const Text(
            "Choose the types of medical tests you do:",
            style: TextStyle(
              fontSize: 22.5,
              fontFamily: 'ultra',
              shadows: [
                Shadow(
                    color: Colors.teal,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,

            ),
          ),

              ),

              const Divider(
                height: 40,
              ),
              // display selected items
              Wrap(
                children: _selectedItems
                    .map((e) => Chip(
                  label: Text(e),
                ))
                    .toList(),
              ),
              const SizedBox(height: 200),
              Container(

                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text('Next'.toUpperCase(), style: const TextStyle(fontSize: 20,fontFamily: 'ultra' , color: Colors.white),),
                  ),
                  onPressed: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => dd(data:widget.data,medicalTests:_selectedItems)));
                  },
                ),
              )

            ],

          ),
        ),


      ),

    );
  }
}