import 'package:flutter/material.dart';
import 'package:apps/farmerdashboard.dart';

class farmd extends StatelessWidget {
  static String tag = 'home-page';
  List list;
  int index;
  farmd({this.index,this.list});

  @override
  Widget build(BuildContext context) {
    final home = Padding(
        padding: EdgeInsets.only(left: 10),
        child: IconButton(icon: Icon(Icons.home), color: Colors.black45, onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> farmerdash()));
        },)
    );
    final alucard = Hero(
      tag: 'hero',

      child: Padding(

        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage('https://breaktalks.com/isf/img/field_officer/'+list[index]['farm_images']),

        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        list[index]['farm_id'],
        style: TextStyle(fontSize: 28.0, color: Colors.white,fontFamily: 'JosefinSans'),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        list[index]['base_location_name'],
        style: TextStyle(fontSize: 28.0, color: Colors.white,fontFamily: 'JosefinSans'),
      ),
    );
    final lorems = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        list[index]['description'],
        style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily: 'JosefinSans'),
      ),

    );
    final email = Padding(
      padding: EdgeInsets.all(8.0),

      child:
      Text('Soil Type: '+
          list[index]['soil_type_name'],
        style: TextStyle(fontSize: 25.0, color: Colors.white,fontFamily: 'JosefinSans'),
      ),
    );
    final mobile = Padding(
      padding: EdgeInsets.all(8.0),

      child:
      Text('Acerage: '+
          list[index]['acreage_name'],
        style: TextStyle(fontSize: 25.0, color: Colors.white,fontFamily: 'JosefinSans'),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.orange[300],
          Color(0xFFFF9100)
        ]),
      ),
      child: Column(
        children: <Widget>[home,alucard, welcome, lorem,lorems,email,mobile],
      ),
    );

    return Scaffold(

      body:

      body,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Color(0xFFFF9100),
        child: Container(
          color: Color(0xFFFF9100),
          margin: EdgeInsets.symmetric(vertical: 25.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }

}
