import 'dart:async';
import 'package:apps/dashboard.dart';
import 'package:apps/investordash.dart';
import 'package:apps/investornavigation/cart_screen.dart';
import 'package:apps/model/crops_model.dart';
import 'package:apps/playground/playground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'InvestorDrawer.dart';

class MyApps extends StatefulWidget {
  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  Future<List<CropsModel>> downloadJSON() async {
    final jsonEndpoint = "http://isf.breaktalks.com/appconnect/crops.php";

    final response = await http.get(jsonEndpoint);

    if (response.statusCode == 200) {
      List spacecrafts = json.decode(response.body);
      return spacecrafts
          .map((spacecraft) => new CropsModel.fromJson(spacecraft))
          .toList();
    } else
      throw Exception('We were not able to download the data.');
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
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => investorss()));
          },
        ),
        title: Text("Add Funds",
            textAlign: TextAlign.center,
            style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white))),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<CropsModel>>(
          future: downloadJSON(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CropsModel> spacecrafts = snapshot.data;
              return ((spacecrafts ?? []).length == 0)
                  ? Center(child: Text('No Data Found'))
                  : CustomListView(spacecrafts);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Please Wait while Data is being fetched from our Servers!'));
            }
            return Center(child: new CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        onPressed: () {
          setState(() {
            downloadJSON();
          });
        },
        child: Icon(
          Icons.download_sharp,
          color: Colors.white,
        ),
      ),
      drawer: InvestorDrawer.getdrawer(context, onpop: () {
        _popup(context);
      }),
    );
  }

  // ignore: non_constant_identifier_names

}

// class Spacecraft {
//   final String id;
//   final int quantity;

//   final String name, imageUrl, propellant;

//   Spacecraft({
//     this.id,
//     this.name,
//     this.imageUrl,
//     this.quantity,
//     this.propellant,
//   });

//   factory Spacecraft.fromJson(Map<String, dynamic> jsonData) {
//     return Spacecraft(
//       id: jsonData['crops_id'],
//       name: jsonData['crops_name'],
//       propellant: jsonData['description'],
//       imageUrl: "https://breaktalks.com/isf/img/field_officer/" +
//           jsonData['crops_image'],
//     );
//   }
// }

//Future is n object representing a delayed computation.


class SecondScreen extends StatefulWidget {
  final CropsModel value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<CropsModel> _cartList = List<CropsModel>();
  int _quantity = 1;
  int price = 5000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xFFFF9100),
          title: new Text('Add to Cart'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0),
              child: GestureDetector(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Icon(Icons.shopping_cart, size: 36.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _cartList.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (_cartList.isNotEmpty)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => cart(),
                      ),
                    );
                },
              ),
            )
          ],
        ),
        body: new Container(
          child: new Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                ),
                Padding(
                  //`widget` is the current configuration. A State object's configuration
                  //is the corresponding StatefulWidget instance.
                  child: Image.network(
                    '${widget.value.cropsImage}',
                    fit: BoxFit.contain,
                  ),
                  padding: EdgeInsets.all(12.0),
                ),
                Padding(
                  child: new Text(
                    'NAME : ${widget.value.cropsName}',
                    style: new TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(12.0),
                ),
                Padding(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Quantity',
                        ),
                        margin: EdgeInsets.only(bottom: 2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 55,
                            height: 55,
                            child: OutlineButton(

                              onPressed: () {
                                setState(() {
                                  _quantity += 1;
                                  _quantity * 5000;
                                  print(_quantity);
                                });
                              },
                              child: Icon(Icons.add),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              _quantity.toString(),
                            ),
                          ),
                          Container(
                            width: 55,
                            height: 55,
                            child: OutlineButton(
                              onPressed: () {
                                setState(() {
                                  if (_quantity == 1) return;
                                  _quantity -= 1;
                                  // _quantity * price;
                                });
                              },
                              child: Icon(Icons.remove),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
                Padding(
                  //`widget` is the current configuration. A State object's configuration
                  //is the corresponding StatefulWidget instance.
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: (!_cartList.contains('${widget.value.cropsName}'))
                          ? Icon(
                              Icons.add_circle,
                              size: 70.0,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                      onTap: () {
                        setState(() {
                          if (!_cartList.contains(CropsModel(
                              cropsName: '${widget.value.cropsName}')))
                            _cartList.add(CropsModel(
                                cropsName: '${widget.value.cropsName}',
                                cropsImage: '${widget.value.cropsImage}'));
                          else
                            _cartList.remove(CropsModel(
                                cropsName: '${widget.value.cropsName}'));
                        });
                      },
                    ),
                  ),
                  padding: EdgeInsets.all(12.0),
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

//end

class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

// ignore: camel_case_types
class _cartState extends State<cart> {
  Future<List> getdata() async {
    var url = "https://breaktalks.com/isf/appconnect/cart.php";
    final response = await http.get(url);
    var dataReceived = json.decode(response.body);
    print(dataReceived);
    return dataReceived;
  }

  @override
  void initstate() {
    // getData();
    super.initState();
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
              'Add Invest',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => investorss()));
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApps()));
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
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFFF9100),
          title: Text(
            "Cart",
            style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[],
        ),
        body: new FutureBuilder<List>(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            return snapshot.hasData
                ? new Cart(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );

          },
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
              children: <Widget>[
                FlatButton(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  color: Colors.orange[50],
                  onPressed: () {
                    _popup(context);
                  },
                  child: Text(
                    "Procced to Pay",
                    style: TextStyle(fontFamily: 'JosefinSans'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  final List list;
  Cart({this.list});
  TextEditingController controllerPassword;
  int name = 5000;
  int names;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          int quantity = 1;

          return Material(
            color: Colors.white,
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
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://breaktalks.com/isf/img/field_officer/834942712profile.png'),
                          minRadius: 35,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          list[i]['crops_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerPassword,
                          decoration: new InputDecoration(
                            hintText: "Quatity",
                            labelText: "Quantity",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          'Rs. ${name * quantity}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans'),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  onTap: () {
                                    void deleteData() {
                                      var url =
                                          "https://breaktalks.com/isf/appconnect/deletecart.php";
                                      http.post(url,
                                          body: {'id': list[i]['id']});
                                    }

                                    deleteData();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Crops Deleted from Cart'),
                                      duration: Duration(seconds: 3),
                                    ));
                                    Future.delayed(Duration(seconds: 2), () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => cart()));
                                    });
                                  },
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
