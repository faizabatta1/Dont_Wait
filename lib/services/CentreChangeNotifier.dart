import 'package:flutter/material.dart';

class CentreChangeNotifier extends ChangeNotifier{
  late Map current_centre;

  CentreChangeNotifier({required this.current_centre});

  void setCurrentCentre(Map centreData){
    current_centre = centreData;
    notifyListeners();
  }
}