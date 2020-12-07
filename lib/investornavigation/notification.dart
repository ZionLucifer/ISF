import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apps/investordash.dart';
import 'package:apps/loginpage.dart';
import 'package:apps/model/investor_notification.dart';
import '../farmreporting/farm_work_reporting.dart';
import 'InvestorDrawer.dart';

class InvestFarm {
  String id;
  String farmername;
  String cropname;
  String title;
  String description;
  String fromdate;
  String todate;
  List file;
  InvestFarm({
    this.id,
    this.farmername,
    this.cropname,
    this.title,
    this.description,
    this.fromdate,
    this.todate,
    this.file,
  });
  factory InvestFarm.fromMap(Map<String, dynamic> map) {
    final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
    final input = map['files'];
    final result = regExp
        .allMatches(input)
        .map((m) => m.group(1))
        .map((item) => item.replaceAll(new RegExp(r'[\[\],]'), ''))
        .map((m) => m)
        .toList();
    if (map == null) return null;
    return InvestFarm(
      id: map['farm_id'],
      farmername: map['farmer_name'],
      cropname: map['crops_name'],
      title: map['title'],
      description: map['description'],
      fromdate: map['from_date'],
      todate: map['to_date'],
      file: result,
    );
  }
}

// ignore: camel_case_types
class farmernoti extends StatefulWidget {
  @override
  _farmernotiState createState() => _farmernotiState();
}

// ignore: camel_case_types
class _farmernotiState extends State<farmernoti> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;
  List<InvestFarm> overview = [];
  Future<List<InvestFarm>> _getOverViewInfo() async {
    try {
      var response = await http.post(
          "http://isf.breaktalks.com/appconnect/farmupdates.php",
          body: {"invester_id": userId});
      var value = json.decode(response.body);
      print('RES :: ${value.length} << $userId  == ${response.statusCode}');
      if (response.statusCode == 200) {
        overview =
            value.map((e) => InvestFarm.fromMap(e)).cast<InvestFarm>().toList();
        return overview ?? [];
      } else
        throw Exception(
            'We were not able to successfully download the json data.');
    } catch (e) {
      debugPrint('Eror :: $e');
      return [];
    }
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _popup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Alert',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            content: Text(
              'Are Your Sure Want to logout',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  // _textfield.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //_textfield.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Farm Update",
            textAlign: TextAlign.center,
            style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => investorss()),
                (route) => false);
          },
        ),
        actions: [],
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<InvestFarm>>(
            future: _getOverViewInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // List<InvestFarm> overview = snapshot.data ?? [];
                // print('$overview');
                return (overview.length == 0)
                    ? Center(child: Text('No Data Found'))
                    : FarmListView(overview);
              }
              return Center(
                  child: Container(
                      child: new CircularProgressIndicator(
                          backgroundColor: Colors.orange[300])));
            }),
      )),
      drawer: InvestorDrawer.getdrawer(context, onpop: () {
        _popup(context);
      }),
    );
  }
}

class Noti extends StatefulWidget {
  final List list;
  const Noti({Key key, this.list}) : super(key: key);
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  String textHolder = 'Unread';

  changeText() {
    setState(() {
      textHolder = 'Seen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Card(
              shadowColor: Colors.orange,
              elevation: 2,
              color: Colors.white,
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
                          widget.list[i]['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans',
                              color: Colors.orange),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          widget.list[i]['description'],
                          style: TextStyle(
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans',
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: FlatButton(
                            onPressed: () {
                              _displaydialog(context);
                            },
                            child: Text(
                              "Reply",
                              style: (TextStyle(
                                  fontFamily: 'JosefinSans',
                                  color: Colors.orange)),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: FlatButton(
                            onPressed: () {
                              changeText();
                            },
                            child: Text(
                              '$textHolder',
                              style: (TextStyle(
                                  fontFamily: 'JosefinSans',
                                  backgroundColor: Colors.orange[300])),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

_displaydialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
                  Navigator.pop(context);
                  senddata();
                },
                child: new Text(
                  'Send',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ))
          ],
        );
      });
}

TextEditingController _textfield = TextEditingController();
// ignore: missing_return
Future<List> senddata() async {
  final response = await http.post(
      "https://breaktalks.com/isf/appconnect/sendmessage.php",
      body: {"send_receive_message": _textfield.text, "sender_id": 'INV001'});

  name();
}

void name() {
  _textfield.clear();
}

class FarmListView extends StatelessWidget {
  final List<InvestFarm> farmList1;
  FarmListView(this.farmList1);
  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(InvestFarm farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FarmUpdateDetails(farmList: farmList)));
          },
          child: ListTile(
            title: Text(
              farmList.title.toString() != "" ? "${farmList.title}" : "N/A",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            subtitle: Text(
              "${farmList.id ?? 'ID'} :  ${farmList.farmername ?? '-'}\n"
              "Crop : ${farmList.cropname ?? ''}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
          )),
    );
  }
}

class FarmUpdateDetails extends StatefulWidget {
  final InvestFarm farmList;
  FarmUpdateDetails({Key key, this.farmList}) : super(key: key);

  @override
  _FarmUpdateDetailsState createState() => _FarmUpdateDetailsState();
}

class _FarmUpdateDetailsState extends State<FarmUpdateDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Farm Update Details",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(8.8),
                child: Text(
                  "Title: ${widget.farmList.title}",
                  style: TextStyle(
                      color: Color(0xff4749A0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              details('Crop Name', widget.farmList.cropname),
              details('Farmer Name', widget.farmList.farmername),
              details('From', widget.farmList.fromdate),
              details('To', widget.farmList.todate),
              details('Description', widget.farmList.description),
              SizedBox(height: 10),
              if (widget.farmList.file != null)
                Container(
                  padding: const EdgeInsets.all(8.8),
                  child: Text(
                    "Images:",
                    style: TextStyle(
                        color: Color(0xff4749A0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (widget.farmList.file != null)
                ListView.separated(
                  itemCount: widget.farmList.file.length,
                  separatorBuilder: (c, i) => Divider(height: 2),
                  itemBuilder: (ctx, idx) {
                    return Image.network(
                      widget.farmList.file[idx],
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (c, i, o) => Divider(height: 1),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

// title, description,
  Widget details(String one, String two) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Text(one, style: TextStyle(fontSize: 16)), width: 110),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                two ?? 'N\A',
                style: TextStyle(color: Colors.black, fontSize: 16),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
