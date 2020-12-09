import 'dart:convert';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../investordash.dart';

class Chating extends StatefulWidget {
  @override
  _ChatingState createState() => _ChatingState();
}

class _ChatingState extends State<Chating> {
  Future<List> getdata() async {
    var url = "https://breaktalks.com/isf/appconnect/message.php";
    final response = await http.get(url);
    var dataReceived = json.decode(response.body);
    // print(dataReceived);
    return dataReceived;
  }

  @override
  void initstate() {
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFFF9100),
          title: Text(
            "My Messages",
            style: TextStyle(fontFamily: 'JosefinSans'),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => investorss()));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Promodel()));
              },
            ),
          ],
        ),
        body: new GroupWindow(),
        // new FutureBuilder<List>(
        //   future: getdata(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) print(snapshot.error);
        //     return snapshot.hasData
        //         ? new ChatWindow(
        //             list: snapshot.data,
        //           )
        //         : new Center(
        //             child: new CircularProgressIndicator(
        //               backgroundColor: Colors.orange,
        //             ),
        //           );
        //   },
        // ),
      ),
    );
  }
}

// ignore: unused_element
Widget _request() {
  return Container(
    height: 50.0,
    child: RaisedButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB9F65A), Color(0xFFFF9100)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            "Farm updates",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'JosefinSans'),
          ),
        ),
      ),
    ),
  );
}

class GroupWindow extends StatefulWidget {
  @override
  _GroupWindowState createState() => _GroupWindowState();
}

class _GroupWindowState extends State<GroupWindow> {
  Future<List> getdata() async {
    var url = "https://breaktalks.com/isf/appconnect/message.php";
    final response = await http.get(url);
    var dataReceived = json.decode(response.body);
    // print(dataReceived);
    return dataReceived;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          backgroundColor: Colors.white,
          title: Text(
            'Chats',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[],
        ),
        body: new FutureBuilder<List>(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CustomHeading(
                          title: 'Direct Messages',
                        ),
                        Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatWindow(
                                    list: snapshot.data,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(50),
                                    offset: Offset(0, 0),
                                    blurRadius: 5,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        child: CircleAvatar(
                                          child: Icon(
                                            Icons.people,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          minRadius: 35,
                                          backgroundColor: Colors.orange[200],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Customer Care',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text(
                                          "Message",
                                          style: TextStyle(
                                            color: Color(0xff8C68EC),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
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
                        )
                      ],
                    ),
                  )
                : new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ChatWindow extends StatefulWidget {
  final List list;
  ChatWindow({this.list});

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  SharedPreferences sharedPreferences;

  String userId, mobile;

  TextEditingController name = new TextEditingController();

  ScrollController scrollController;

  bool enableButton = false;

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
        print("Test Else");
        print(userId);
        print(mobile);
      }
    });
  }

  Future<List> senddata() async {
    final response = await http.post(
        "https://breaktalks.com/isf/appconnect/sendmessage.php",
        body: {"send_receive_message": name.text, "sender_id": userId});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.list);
    var textInput = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: "Type a message",
              ),
              controller: name,
            ),
          ),
        ),
        IconButton(
          color: Colors.orange,
          icon: Icon(
            Icons.send,
          ),
          onPressed: () {
            senddata();
            Future.delayed(Duration(seconds: 2), () {
              // 5s over, navigate to a new page
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Chating()));
            });
          },
        )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          "Customer Care",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.list == null ? 0 : widget.list.length,
              itemBuilder: (context, index) {
                bool reverse;

                if (widget.list[index]['sender_id'] != '' &&
                    widget.list[index]['receiver_id'] != '' &&
                    widget.list[index]['support_sender_id'] == '') {
                  reverse = false;
                } else if (widget.list[index]['sender_id'] != '' &&
                    widget.list[index]['receiver_id'] == '' &&
                    widget.list[index]['support_sender_id'] == '') {
                  reverse = true;
                }

                var avatar = Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      "I",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
                var avatars = Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text("C", style: TextStyle(color: Colors.white)),
                  ),
                );

                var triangle = CustomPaint(
                  painter: Triangle(),
                );

                var messagebody = DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.list[index]['send_receive_message'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );

                Widget message;

                if (reverse == true) {
                  message = Stack(
                    children: <Widget>[
                      messagebody,
                      Positioned(right: 0, bottom: 0, child: triangle),
                    ],
                  );
                } else if (reverse == false) {
                  message = Stack(
                    children: <Widget>[
                      Positioned(left: 0, bottom: 0, child: triangle),
                      messagebody,
                    ],
                  );
                }

                if (reverse == true) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                          width: 150,
                      ),
                      Expanded(
                                              child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message,
                        ),
                      ),
                      avatar,
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      avatars,
                      Expanded(
              
                                              child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message,
                        ),

                      ),
                       SizedBox(
                          width: 150,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Divider(height: 2.0),
          textInput
        ],
      ),
    );
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.orange[50];

    var path = Path();
    path.lineTo(10, 0);
    path.lineTo(0, -10);
    path.lineTo(-10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomHeading extends StatelessWidget {
  final String title;

  const CustomHeading({Key key, @required this.title}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            width: 30,
            height: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 1],
                  colors: [
                    Color(0xFF8C68EC),
                    Color(0xFF3E8DF3),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
