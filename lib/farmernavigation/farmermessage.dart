import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apps/farmerdashboard.dart';
import 'package:apps/loginpage.dart';

class farmermsg extends StatefulWidget {
  @override
  _farmermsgState createState() => _farmermsgState();
}

class _farmermsgState extends State<farmermsg> {
  List<String> notes = [
    "Some Messages",
    "Another Messages",
    "Welcome Messages"
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Color(0xFFFF9100),
          title: Text(
            "Messages",
            style: (TextStyle(fontFamily: 'JosefinSans')),
          ),
          leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(Icons.home),
                color: Colors.black45,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => farmerdash()));
                },
              )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.orange[50],
                  padding: EdgeInsets.all(16.0),
                  child: Noti(notes),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          color: Color(0xFFFF9100),
          child: Container(
            color: Color(0xFFFF9100),
            margin: EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[],
            ),
          ),
        ),
      ),
    );
  }
}

class Noti extends StatelessWidget {
  final List<String> notes;
  Noti(this.notes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, pos) {
        return Material(
          color: Colors.orange[50],
          child: InkWell(
            onTap: () {
              _displaydialog(context);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange[300],
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.orange[50],
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          notes[pos],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                              color: Color(0xFFFF9100),
                              fontSize: 14,
                              fontFamily: 'JosefinSans'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          '11:00 AM',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'JosefinSans'),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

_displaydialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange[50],
          title: Text(
            'Reply',
            style: TextStyle(fontFamily: 'JosefinSans'),
          ),
          content: TextField(
            controller: _textfield,
            decoration: InputDecoration(hintText: "Type Your message"),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  _textfield.clear();
                  Navigator.pop(context);
                },
                child: new Text(
                  'Send',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.orange[300],
                      fontWeight: FontWeight.bold),
                ))
          ],
        );
      });
}

TextEditingController _textfield = TextEditingController();
