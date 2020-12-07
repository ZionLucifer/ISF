import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final List<String> imgList = [
    'https://m.hindustantimes.com/rf/image_size_444x250/HT/p2/2019/03/22/Pictures/chandigarh-outskirts-hindustan-ludhiana-bothgarh-working-chandigarh_08e52426-4ccc-11e9-9111-3135b956f139.jpg',
    'https://www.straitstimes.com/sites/default/files/styles/article_pictrure_780x520_/public/articles/2018/10/16/nz-indiafarmer-131018.jpg?itok=k6QLKWxv&timestamp=1539676648',
    'https://www.indiawaterportal.org/sites/indiawaterportal.org/files/styles/node_lead_image_new/public/farmer_10.jpg?itok=sKDU0j-i',
    'https://www.thestatesman.com/wp-content/uploads/2018/03/IRRIGATION.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Center(
            child: CarouselSlider(
              autoPlay: true,
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              height: 250.0,
              viewportFraction: 1.0,
              items: imgList.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: i,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ));
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
