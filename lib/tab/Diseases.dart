import 'package:carousel_slider/carousel_slider.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:flutter/material.dart';

import '../services/news.dart';
import 'NewsConainer.dart';

class Diseases extends StatefulWidget {

  @override
  State<Diseases> createState() => _DiseasesState();
}

class _DiseasesState extends State<Diseases> {
  Future<dynamic>? api;

  @override
  void initState() {
    super.initState();
    api = getData(url: "http://10.0.2.2:3000/api/diseas");
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child:FutureBuilder(
          future: api,
          builder: (context,snapshot){
            if(!snapshot.hasError && snapshot.hasData){
              List data = snapshot.data;
              return CarouselSlider.builder(

                itemCount: data.length,
                itemBuilder: (BuildContext context,int index,int pageIndex){
                  return NewsContainer(currentNews: data[index]);
                }, options: CarouselOptions(
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                  enableInfiniteScroll: true,
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  enlargeCenterPage: true,

                  initialPage: 0
              ),
              );
            }else{
              return Container(
                child: const Text("no data"),
              );
            }
          },
        ) ,
      ),
    );
  }
}