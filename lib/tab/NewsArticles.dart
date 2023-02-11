import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/news.dart';
import 'package:flutter/material.dart';

import 'NewsConainer.dart';



class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<dynamic>? api;

  @override
  void initState() {
    super.initState();
    api = getData(url: "http://10.0.2.2:3000/api/news");
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        child: Center(

          child:FutureBuilder(
            future: api,
            builder: (context,snapshot){
              if(snapshot.hasData && !snapshot.hasError){
                List data = snapshot.data;
                return CarouselSlider.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context,int index,int pageIndex){
                    return NewsContainer(currentNews: data[index],);
                    }, options: CarouselOptions(
                  enableInfiniteScroll: true,

                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  enlargeCenterPage: true,
                    initialPage: 0,

                  ),
                );
              }else{
                return Center(
                  child: Text("no data"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
