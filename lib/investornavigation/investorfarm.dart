import 'dart:convert';
import 'package:apps/dashboard.dart';
import 'package:apps/investordash.dart';
import 'package:apps/investornavigation/dashboard_screen.dart';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:apps/model/investor_farm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../fieldofficernavigation/pending/detail_approved_farm.dart';
import 'InvestorDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';

class Farms extends StatefulWidget {
  @override
  _FarmsState createState() => _FarmsState();
}

class _FarmsState extends State<Farms> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;

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

  Future<List<InvestorFarm>> _getOverViewInfo() async {
    print('...');
    var response = await http.post(
        "https://breaktalks.com/isf/appconnect/investerfarmbyinvesterId.php",
        body: {"invester_id": userId});
    var value = jsonDecode(response.body);
    print(value.runtimeType);

    // var farmlist = value;
    if (response.statusCode == 200) {
      // List<InvestorFarm> spacecrafts = (value as List).map((e) => print(e));
      // new InvestorFarm.fromJson(e))
      //     .toList();
      print("spacecrafts");

      List<InvestorFarm> list = new List<InvestorFarm>();
      for(var i = 0; i < value.length; i++){
        // print(value[i]);
        // print(InvestorFarm.fromJson(value[i]).toJson());
        list.add(InvestorFarm.fromJson(value[i]));
      }
      // print(spacecrafts);
      print(list.length);
      return list;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    // TODO: implement initState
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
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
        title: Text(
          "My Farms",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
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
            height: MediaQuery.of(context).size.height / 1.2,
            child: FutureBuilder<List<InvestorFarm>>(
                future: _getOverViewInfo(),
                builder: (context, snapshot) {
                  print("snapshot");
                  print(snapshot.data);

                  if (snapshot.hasData) {
                    List<InvestorFarm> overview = snapshot.data;
                    return (overview.length == 0)
                        ? Center(child: Text('No Data Found'))
                        : FarmListView(overview);
                  } else if (snapshot.hasError) {
                    // return Text(snapshot.error.toString())

                    print(snapshot.error)

                      ;
                    //   Center(
                    //     child:
                    //     CircularProgressIndicator(
                    //         backgroundColor: Colors.orange)
                    // );
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

class FarmListView extends StatelessWidget {
  final List<InvestorFarm> farmList1;
  FarmListView(this.farmList1);

  Widget build(context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) {
        return Divider(height: 2, thickness: 2, indent: 5, endIndent: 5);
      },
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      InvestorFarm farmList, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailApprovedFarm(farmInfo: farmList)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange[100],
                        child: Image.network(farmList.farmphoto,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (c, n, o) => Icon(
                                Icons.account_circle,
                                color: Colors.white))),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("Farmer ID"),
                      // SizedBox(height: 2),
                      Text("Farmer ID"),
                      SizedBox(height: 2),
                      Text("Farm ID"),
                      SizedBox(height: 2),
                      Text("Base Location"),
                      SizedBox(height: 2),
                      Text("Crop"),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(":"),
                      // SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   farmList.farmerId == null
                      //       ? "N/A"
                      //       : "${farmList.farmerId}",
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(height: 2),
                      Text(
                        farmList.farmerId == null
                            ? "N/A "
                            : "${farmList.farmerId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        farmList.farmId == null ? "N/A " : "${farmList.farmId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        farmList.baseLocation == null
                            ? "N/A "
                            : "${farmList.baseLocation}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        farmList.crops == null ? "N/A " : "${farmList.crops}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Image.network(farmList.irrigation,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (c, n, o) => Icon(Icons.photo,
                              color: Colors.orange[200], size: 50))),
                )
              ],
            )),
      ),
    );
  }
}

class DetailApprovedFarm extends StatelessWidget {
  final InvestorFarm farmInfo;
  DetailApprovedFarm({this.farmInfo});
  @override
  Widget build(BuildContext context) {
    List latlong = farmInfo.latlong.split(',');
    Set<Polygon> _polygons = HashSet<Polygon>();
    List<LatLng> points = [];
    if (farmInfo.boundaries != null) {
      farmInfo.boundaries.forEach((e) {
        points.add(LatLng(e.first, e.last));
      });
    }
    _polygons.add(Polygon(
      polygonId: PolygonId('polygonIdVal'),
      points: points,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    ));
    Widget map() {
      return Container(
        height: 250,
        padding: EdgeInsets.all(10),
        child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(double.tryParse(latlong.first) ?? 0,
                    double.tryParse(latlong.last) ?? 0),
                zoom: 16),
            mapType: MapType.hybrid,
            polygons: _polygons,
            myLocationEnabled: true),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          farmInfo.farmId,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.orange[300]),
                  child: Center(
                    child: Image.network(
                      farmInfo.farmphoto ?? '',
                      errorBuilder: (c, i, o) =>
                          Icon(Icons.image, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.8),
                  child: Text(
                    "Farm Information",
                    style: TextStyle(color: Color(0xff4749A0), fontSize: 18),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Farmer ID",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${farmInfo.farmerId}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                details("Land Type", farmInfo.landType),
                Divider(color: Colors.black),
                details("Irrigation", farmInfo.irrigation),
                Divider(color: Colors.black),
                details("Soil Type", farmInfo.soilType),
                Divider(color: Colors.black),
                details("Acerage", farmInfo.acerage),
                Divider(color: Colors.black),
                details("Plots", farmInfo.plots),
                Divider(color: Colors.black),
                details("Description", farmInfo.description),
                Divider(color: Colors.black),
                SizedBox(height: 10),
                map(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget details(String one, String two) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(one, style: TextStyle(fontSize: 16)),
          Text(two ?? '-', style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}

// // ignore: must_be_immutable
// class FarmListView extends StatelessWidget {
//   final List<InvestorFarm> farmList1;
//   FarmListView(this.farmList1);
//   SharedPreferences sp;

//   Widget build(context) {
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: farmList1.length,
//       itemBuilder: (context, int currentIndex) {
//         //print(farmList1[currentIndex]);
//         return createViewItem(farmList1[currentIndex], context, currentIndex);
//       },
//     );
//   }

// //
//   Widget createViewItem(
//       InvestorFarm farmList, BuildContext context, int index) {
//     return Card(
//       elevation: 1,
//       color: Colors.white,
//       child: InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         DetailApprovedFarm(farmInfo: farmList)));
//           },
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.orange[300],
//               child: Text(
//                 "${farmList.id}",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             title: Text(
//               "${farmList.cropsName}",
//               style: TextStyle(
//                 color: Color(0xff1D2952),
//               ),
//             ),
//             subtitle: Text(
//               "${farmList.description}",
//               style: TextStyle(
//                 color: Color(0xff1D2952),
//               ),
//             ),
//           )),
//     );
//   }
// }

// ignore: must_be_immutable
// class farmerdes extends StatelessWidget {
//   static String tag = 'home-page';
//   List list;
//   int index;
//   farmerdes({this.index, this.list});

//   @override
//   Widget build(BuildContext context) {
//     final home = Padding(
//         padding: EdgeInsets.only(left: 10),
//         child: IconButton(
//           icon: Icon(Icons.home),
//           color: Colors.black45,
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => investorss()));
//           },
//         ));
//     final alucard = Hero(
//       tag: 'hero',
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: CircleAvatar(
//           radius: 72.0,
//           backgroundColor: Colors.transparent,
//           backgroundImage: NetworkImage(
//               'https://breaktalks.com/isf/img/field_officer/' +
//                   list[index]['farm_images']),
//         ),
//       ),
//     );

//     final welcome = Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         list[index]['crops_name'],
//         style: TextStyle(
//             fontSize: 28.0, color: Colors.white, fontFamily: 'JosefinSans'),
//       ),
//     );

//     final lorem = Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         'Farmer ID: ' + list[index]['farmer_id'],
//         style: TextStyle(
//             fontSize: 28.0, color: Colors.white, fontFamily: 'JosefinSans'),
//       ),
//     );
//     final lorems = Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         list[index]['description'],
//         style: TextStyle(
//             fontSize: 16.0, color: Colors.white, fontFamily: 'JosefinSans'),
//       ),
//     );
//     final email = Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         'Farm ID: ' + list[index]['farm_id'],
//         style: TextStyle(
//             fontSize: 25.0, color: Colors.white, fontFamily: 'JosefinSans'),
//       ),
//     );

//     final body = Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.all(28.0),
//       decoration: BoxDecoration(
//         gradient:
//             LinearGradient(colors: [Colors.orange[300], Color(0xFFFF9100)]),
//       ),
//       child: Column(
//         children: <Widget>[home, alucard, welcome, lorem, lorems, email],
//       ),
//     );

//     return Scaffold(
//       body: body,
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0.0,
//         color: Color(0xFFFF9100),
//         child: Container(
//           color: Color(0xFFFF9100),
//           margin: EdgeInsets.symmetric(vertical: 25.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class myfarm extends StatelessWidget {
//   final List list;
//   myfarm({this.list});
//   @override
//   Widget build(BuildContext context) {
//     return new ListView.builder(
//         itemCount: list == null ? 0 : list.length,
//         itemBuilder: (context, i) {
//           return Material(
//             color: Colors.white,
//             child: InkWell(
//               onTap: () => Navigator.of(context).push(
//                 new MaterialPageRoute(
//                     builder: (BuildContext context) => new farmerdes(
//                           list: list,
//                           index: i,
//                         )),
//               ),
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.orange[300],
//                       offset: Offset(0, 0),
//                       blurRadius: 5,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.white,
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Stack(
//                       children: <Widget>[
//                         Container(
//                           child: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 'https://breaktalks.com/isf/img/field_officer/' +
//                                     list[i]['crops_image']),
//                             minRadius: 35,
//                             backgroundColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             list[i]['crops_name'],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orange,
//                                 fontSize: 18.0,
//                                 height: 1.6,
//                                 fontFamily: 'JosefinSans'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 5),
//                           ),
//                           Text(
//                             list[i]['description'],
//                             style: TextStyle(
//                                 color: Colors.orange,
//                                 fontSize: 14,
//                                 fontFamily: 'JosefinSans'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 5),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(right: 15),
//                           child: Icon(
//                             Icons.chevron_right,
//                             size: 18,
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
