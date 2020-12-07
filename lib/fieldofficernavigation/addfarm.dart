import 'dart:convert';
import 'dart:io';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/pending_requests.dart';
import 'package:apps/fieldofficernavigation/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../Utils/Image/PickImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addfarmer.dart';
import 'package:geolocator/geolocator.dart';
import '../components/logout_overlay.dart' as ord;
import '../Utils/GLocation/GLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AndroidMessagesPages extends StatefulWidget {
  @override
  _AndroidMessagesPagesState createState() => _AndroidMessagesPagesState();
}

class _AndroidMessagesPagesState extends State<AndroidMessagesPages> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  TextEditingController descController = new TextEditingController();
  TextEditingController acerageController = new TextEditingController();
  TextEditingController enterpriseController = new TextEditingController();
  TextEditingController farmerScore1Controller = new TextEditingController();
  TextEditingController farmerScore2Controller = new TextEditingController();
  TextEditingController farmerScore3Controller = new TextEditingController();
  TextEditingController farmerScore4Controller = new TextEditingController();
  TextEditingController helthfactor = new TextEditingController();
  TextEditingController plotController = new TextEditingController();
  String userId;
  bool isGoingDown = true;
  String _farmerId;
  String _landType;
  String _irrigation;
  String _soilType;
  String _baseLocation;
  List _farmerListId = [];
  Position position;
  bool loading = true;
  Set<Polygon> polygons;
  File _farmImage;
  String positionvals;

  get ScaffoldMessenger => null;
  Future getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget displayFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file, fit: BoxFit.contain),
    );
  }

  Future getFarmImage() async {
    // final image =
    // await picker.getImage(imageQuality: 50, source: ImageSource.camera);
    String path = await ImageUtils.getimage(context);
    setState(() {
      _farmImage = File(path);
    });
  }

  void _popup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.orange[50],
            title: Text(
              'Alert',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            content: Text(
              'Farm Added  Successfully',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => fielddash()));
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.orange[300],
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  // Widget displaylocation(Set<Polygon> polygons) {
  //   return new Container();
  // }
  void showloading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('       Uploading Data...')
              ],
            ),
          )),
    );
  }

  _sendData() async {
    try {
      showloading();
      List polygon = [];
      if (polygons.length > 0) {
        polygon = polygons
            ?.map((e) =>
            e.points.map((e) => '[${e.latitude},${e.longitude}]').toList())
            ?.toList();
      }

      print("Sending data > $polygon");
      positionvals =
          position.latitude.toString() + "," + position.longitude.toString();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://isf.breaktalks.com/appconnect/addFarm.php"),
      )
        ..fields['field_officer_id'] = userId
        ..fields['farmer_id'] = _farmerId.split('/').first.trim().toString()
        ..fields['land_type'] = _landType.toString()
        ..fields['soil_type'] = _soilType
        ..fields['acerage'] = acerageController.text.toString()
        ..fields['base_location'] = _baseLocation.toString()
        ..fields['enterprise'] = enterpriseController.text.toString()
        ..fields['credit_worthiness'] = farmerScore2Controller.text.toString()
        ..fields['social_credibility'] = farmerScore3Controller.text.toString()
        ..fields['land_factors'] = farmerScore4Controller.text.toString()
        ..fields['farming_experience'] = farmerScore1Controller.text.toString()
        ..fields['health_factors'] = helthfactor.text.toString()
        ..fields['latlong'] = positionvals?.toString()
        ..fields['description'] = descController.text.toString()
        ..fields['status'] = "Pending"
        ..fields['plots'] = plotController.text.toString()
        ..fields['boundaries'] = polygon.first.toString()
      // polygons?.map((e) => e.points.join(','))?.join('')
        ..files.add(
            await http.MultipartFile.fromPath('farm_photo', _farmImage?.path));
      var response = await request.send();
      // var dataresponse = json.decode(response.body);
      print(response);
    } catch (e) {
      print(e);
    }
    setState(() {
      acerageController.clear();
      enterpriseController.clear();
      farmerScore1Controller.clear();
      farmerScore2Controller.clear();
      farmerScore3Controller.clear();
      farmerScore4Controller.clear();
      descController.clear();
      helthfactor.clear();
      _farmImage = null;
      print("All the controllers cleared");
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
      }
    });
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmeridlist.php",
        body: {"field_officer_id": userId});
    // print("Printing the response body");
    var data = jsonDecode(response.body);
    setState(() {
      _farmerListId = data["farmer_id"];
    });
    print(
        "Prinitng the object as a List for Farmer Id from the variable _farmerListId");
    print(_farmerListId);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    acerageController.clear();
    enterpriseController.clear();
    farmerScore1Controller.clear();
    farmerScore2Controller.clear();
    farmerScore3Controller.clear();
    farmerScore4Controller.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Add Farm",
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => fielddash()),
                    (route) => false);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              var result = await showSearch(
                  context: context,
                  delegate: CustomDelegate(data: _farmerListId));
              setState(() {
                _farmerId = result;
              });
              print(_farmerId);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (onScrollNotification) {
                        if (onScrollNotification is ScrollUpdateNotification) {
                          if (onScrollNotification.scrollDelta <= 0.0) {
                            if (!isGoingDown) setState(() => isGoingDown = true);
                          } else {
                            if (isGoingDown) setState(() => isGoingDown = false);
                          }
                        }
                        return false;
                      },
                      child: _buildList(),
                    ),
                  )),
            ),
          ])),
      drawer: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: new Drawer(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => fielddash()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Color(0xff1D2952),
                      ),
                      title: Text("Home",
                          style: TextStyle(color: Color(0xff1D2952))),
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: new Text(
                            "Add Farmer",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.portrait,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPage()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Add Farm",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.filter_frames,
                              color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPages()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Pending Requests",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.list,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingRequests()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Report",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.report, color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportsScreen()));
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: new Text("Logout"),
                          leading: Icon(
                            Icons.cancel,
                            color: Colors.red[200],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _popup(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Powered By Farmingly",
                      style: TextStyle(color: Color(0xff1D2952)),
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildList() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Container(
          width: 100,
          height: (_farmImage == null) ? 100 : 250,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(5.0)),
          child: Center(
            child: _farmImage == null
                ? FlatButton(
              onPressed: () {
                getFarmImage();
              },
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 30,
              ),
            )
                : Column(
              children: [
                Expanded(child: displayFile(_farmImage)),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        _farmImage = null;
                      });
                      getFarmImage();
                    },
                    child: Text(
                      "Retake",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _farmerId,
                    hint: Container(
                      width: 200,
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select Farmer Id',
                            labelText: _farmerListId == null
                                ? 'Please Wait While the data is being fetched'
                                : 'Select Farmer Id',
                            labelStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            contentPadding:
                            new EdgeInsets.symmetric(horizontal: 15.0),
                            border: InputBorder.none,
                          )),
                    ),
                    items:
                    _farmerListId?.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(value),
                        ),
                      );
                    })?.toList() ??
                        [],
                    onChanged: (String value) {
                      setState(() {
                        _farmerId = value;
                      });
                    },
                  ),
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _landType,
                    hint: Container(
                      width: 200,
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select expense',
                            labelText: 'Select Land Type',
                            labelStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            contentPadding:
                            new EdgeInsets.symmetric(horizontal: 15.0),
                            border: InputBorder.none,
                          )),
                    ),
                    items: <String>['Wet Land', 'Garden Land', 'Dry Land']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _landType = value;
                      });
                    },
                  ),
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _irrigation,
                    hint: Container(
                      width: 200,
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select Irrigation Type',
                            labelText: 'Select Irrigation',
                            labelStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            contentPadding:
                            new EdgeInsets.symmetric(horizontal: 15.0),
                            border: InputBorder.none,
                          )),
                    ),
                    items: <String>['Bore Well', 'Canal', 'Well', 'Rainfed']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _irrigation = value;
                      });
                    },
                  ),
                ),
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _soilType,
                    hint: Container(
                      width: 200,
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select Soil Type',
                            labelText: 'Select Soil Type',
                            labelStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            contentPadding:
                            new EdgeInsets.symmetric(horizontal: 15.0),
                            border: InputBorder.none,
                          )),
                    ),
                    items: <String>[
                      'Red soil',
                      'Black soil',
                      'Loam',
                      'Clay Loam',
                      'Laterite',
                      'Hill',
                      'Sandy'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _soilType = value;
                      });
                    },
                  ),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: acerageController,
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: new InputDecoration(
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintText: 'Acreage',
                    labelText: 'Enter Acreage',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: plotController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: new InputDecoration(
                    hintText: 'Plot',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    labelText: 'Enter No of Plots',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _baseLocation,
                    hint: Container(
                      width: 200,
                      child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select Base Location',
                            labelText: 'Select Base Location',
                            labelStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black45),
                            contentPadding:
                            new EdgeInsets.symmetric(horizontal: 15.0),
                            border: InputBorder.none,
                          )),
                    ),
                    items: <String>[
                      'Chennai',
                      'Anumandai',
                      'Puducherry',
                      'Kullanchavadi',
                      'Mayiladuthurai',
                      'Kodaikkanal',
                      'Vridhachalam',
                      'Needamangalam'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _baseLocation = value;
                      });
                    },
                  ),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                // controller: enterprise,
                controller: enterpriseController,
                decoration: new InputDecoration(
                    hintText: 'Enterprise',
                    labelText: 'Enter Enterprise',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: descController,
                keyboardType: TextInputType.multiline,
                decoration: new InputDecoration(
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintText: 'Description',
                    labelText: 'Give Your Description',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: farmerScore1Controller,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    hintText: 'Farming Experience',
                    labelText: 'Farming Experience',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: farmerScore2Controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                decoration: new InputDecoration(
                  hintText: 'Credit Score',
                  labelStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                  hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                  labelText: 'Credit Score out of 10',
                  contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                  border: InputBorder.none,

                ),
                autovalidate: true,
                validator: (value) {
                  RegExp exp = RegExp(
                      "[0-9]");
                  if (value.isEmpty) {
                    return "";
                  }if (!exp.hasMatch(value) ){
                    return "Invalid Score.";
                  }
                  var val = int.parse(value);
                  if(val>10){
                    return "Invalid code";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: farmerScore3Controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                decoration: new InputDecoration(
                    hintText: 'Social Credibility Score',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    labelText: 'Social Credibility out of 10',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
                autovalidate: true,
                validator: (value) {
                  RegExp exp = RegExp(
                      "[0-9]");
                  if (value.isEmpty) {
                    return "";
                  }if (!exp.hasMatch(value) ){
                    return "Invalid Score.";
                  }
                  var val = int.parse(value);
                  if(val>10){
                    return "Invalid code";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: farmerScore4Controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                decoration: new InputDecoration(
                    hintText: 'Land Factors Score',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    labelText: 'Land Factors out of 10',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
                autovalidate: true,
                validator: (value) {
                  RegExp exp = RegExp(
                      "[0-9]");
                  if (value.isEmpty) {
                    return "";
                  }if (!exp.hasMatch(value) ){
                    return "Invalid Score.";
                  }
                  var val = int.parse(value);
                  if(val>10){
                    return "Invalid code";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              width: 200,
              child: new TextFormField(
                controller: helthfactor,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2)
                ],
                decoration: new InputDecoration(
                    hintText: 'Health Factors Score',
                    labelStyle:
                    TextStyle(fontSize: 17.0, color: Colors.black45),
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black45),
                    labelText: 'Health Factors out of 10',
                    contentPadding: new EdgeInsets.symmetric(horizontal: 15.0),
                    border: InputBorder.none),
                autovalidate: true,
                validator: (value) {
                  RegExp exp = RegExp(
                      "[0-9]");
                  if (value.isEmpty) {
                    return "";
                  }if (!exp.hasMatch(value) ){
                    return "Invalid Score.";
                  }
                  var val = int.parse(value);
                  if(val>10){
                    return "Invalid code";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        //
        Container(
          width: 200,
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(5.0)),
          child: Center(
              child: FlatButton.icon(
                  onPressed: () async {
                    // if (position == null) {
                    //   await getLocation();
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Please Wait...')));
                    //   return;
                    // }
                    polygons = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => GooMap(
                                latitude: position?.latitude,
                                longitude: position?.longitude)));
                    if (polygons != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Farm Boundry Updated Successfully')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No Boundry created For Farm')));
                    }
                  },
                  label: Text(
                      (polygons == null)
                          ? 'Locate Farm Boundry'
                          : 'Relocate Farm Boundry',
                      style: TextStyle(color: Colors.white)),
                  icon:
                  Icon(Icons.location_on, color: Colors.white, size: 30))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: new InkWell(
              onTap: () {
                // List polygon = polygons
                //     ?.map((e) => e.points
                //         .map((e) => '[${e.latitude},${e.longitude}]')
                //         .toList())
                //     ?.toList();
                print("Sending data > ${polygons != null}");
                if (enterpriseController.text.isNotEmpty &&
                    acerageController.text.isNotEmpty &&
                    farmerScore1Controller.text.isNotEmpty &&
                    farmerScore2Controller.text.isNotEmpty &&
                    farmerScore3Controller.text.isNotEmpty &&
                    farmerScore4Controller.text.isNotEmpty &&
                    plotController.text.isNotEmpty &&
                    helthfactor.text.isNotEmpty) {
                  print("Done clicked");
                  _sendData();
                  setState(() {});
                  showDialog(
                      context: context,
                      builder: (_) => ord.LogoutOverlay(
                        message: "Added Farm",
                      ));
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => ord.LogoutOverlay(
                        message: "Add All fields",
                      ));
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.orangeAccent, Color(0xFFFF9100)])),
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 20,
                      color: Colors.white),
                ),
              )),
        ),
      ],
    );
  }
}

class CustomDelegate<T> extends SearchDelegate<T> {
  final List data;

  CustomDelegate({this.data});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
        icon: Icon(Icons.clear), onPressed: () => close(context, null))
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow =
          data.where((e) => e.contains(query) && e.startsWith(query)).toList();
    else
      listToShow = data;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i];
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = data.where((e) => e.contains(query)).toList();
    else
      listToShow = data;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i];
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );
  }
}
