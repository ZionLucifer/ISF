import 'dart:convert';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/investordash.dart';
import 'package:apps/investornavigation/addfund.dart';
import 'package:apps/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  var isEmpty = false;
  String farmlist;
  List<CartModel> overview;


  Future<List<CartModel>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/cart.php",
        body: {"invester_id": userId});
    var value = json.decode(response.body);
    print('value : $value');
    var farmlist = value['cart'];
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new CartModel.fromJson(spacecraft))
          .toList();
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
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
        print("Test Else");
        print(userId);
        print(mobile);
      }
    });
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/cart.php",
        body: {"invester_id": userId});
    print('response :: ${response.body}');
    var value = json.decode(response.body);
    try {
      setState(() {
        farmlist = value['total_investment'].toString();
      });
    } catch (e) {
      setState(() {
        farmlist = null;
      });
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApps()));
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => investorss()),
                    (route) => false);
              })
        ],
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.8,
            child: FutureBuilder<List<CartModel>>(
                future: _getOverViewInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    overview = snapshot.data ?? [];
                    return (overview.length == 0)
                        ? Center(child: Text('No Data Found'))
                        : FarmListView(overview);
                  }
                  return Center(
                      child: Container(
                          child: new CircularProgressIndicator(
                              backgroundColor: Colors.orange[300])));
                }),
          ),
          SizedBox(height: 3),
          if (farmlist != null) Divider(indent: 30, endIndent: 30),
          if (farmlist != null)
            Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                child: Center(
                  child: Text(
                    farmlist != null ? "₹${farmlist.toString()} Invested" : "",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )),
        ],
      )),
      floatingActionButton: Container(
        color: Colors.orange,
        child: FlatButton(
          onPressed: isEmpty ? null : addtocart,
          child: Text(
            "Procced to Pay",
            style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white),
          ),
        ),
      ),
    );
  }

  void addtocart() {
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
                  http.post(
                      "http://isf.breaktalks.com/appconnect/addInvesterReq.php",
                      body: {"invester_id": userId}).then((response) {
                    if (response.statusCode == 200) {
                      print("${response.statusCode}");
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Success"),
                                content: Text(
                                    "Items in the cart Added Successfully!"),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        _getOverViewInfo();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CartScreen()));
                                      },
                                      child: Text("OK"))
                                ],
                              ));
                    }
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
}
 List<int> qty = [];

// ignore: must_be_immutable
class FarmListView extends StatefulWidget {
  final List<CartModel> farmList1;

  FarmListView(this.farmList1);

  @override
  _FarmListViewState createState() => _FarmListViewState();
}

class _FarmListViewState extends State<FarmListView> {
  SharedPreferences sp;


  void initState() {
    // TODO: implement initState
    super.initState();  
      for(int i = 0; i<100 ; i++){
      qty.add(1);
    }
  }
  @override
  Widget build(context) {
    print(widget.farmList1);
    return widget.farmList1.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.farmList1.length,
            itemBuilder: (context, int currentIndex) {
              return createViewItem(
                  widget.farmList1[currentIndex], context, currentIndex);
            },
          )
        : Center(
            child: Text("No Items in the cart"),
          );
  }

  Widget createViewItem(CartModel farmList, BuildContext context, int i) {
    var quantity = int.tryParse(farmList.quantity);
    // for (var i = 0; i < quantity; i++) {
    //    qty.add(1);
    // }
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(2.0),
                  padding: const EdgeInsets.all(4.5),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange[300]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.network(farmList.cropsImage,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity),
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        farmList.cropsName.toString().toUpperCase() != ""
                            ? "${farmList.cropsName.toString().toUpperCase()}"
                            : "N/A",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 2.2,
                      ),
                      Text(farmList.cropsId.toString().toUpperCase() != ""
                          ? "${farmList.cropsId.toString().toUpperCase()}"
                          : "N/A"),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Quantity x ${farmList.quantity}",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        )),
                      ),
                      Divider()
                    ],
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    child: Flexible(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            // decrementButton(qty),
                            // Text(
                            //   '$qty',
                            //   style: TextStyle(fontSize: 18.0),
                            // ),
      
                            qty[i] != quantity
                                ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () => qty[i]--)
                            
                                : new Container(),
                            Text(qty[i].toString()),
                            new IconButton(
                                icon: new Icon(Icons.add),
                                onPressed: () => qty[i]++)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3.3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Alert"),
                                    content: Text(
                                        "Are you sure you want to delete this item."),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            http.post(
                                                'https://breaktalks.com/isf/appconnect/deletecart.php',
                                                body: {
                                                  'id': farmList.id.toString()
                                                }).then((response) {
                                              if (response.statusCode == 200) {
                                                if (response.statusCode ==
                                                    200) {
                                                  print(
                                                      "${response.statusCode}");
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          LogoutOverlay(
                                                            message:
                                                                "Items Added Succefully",
                                                          ));
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CartScreen()));
                                                }
                                              } else {
                                                print("Could Not delete Item");
                                                Scaffold.of(context)
                                                    .hideCurrentSnackBar();
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Item Could not be Deleted")));
                                              }
                                            });
                                          },
                                          child: Text("yes")),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No"))
                                    ],
                                  ));
                        },
                        child: Text(
                          "Remove From Cart",
                          style: TextStyle(color: Colors.red),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// Future<String> _getInvestment() async {
//   var response = await http.post(
//       "https://isf.breaktalks.com/appconnect/cart.php",
//       body: {"invester_id": userId});

//   var value = json.decode(response.body);
//   print(value["total_investment"]);

//   var farmlist = value['total_investment'];

//   if (response.statusCode == 200) {
//     List spacecrafts = farmlist;

//     return farmlist;
//   } else
//     throw Exception(
//         'We were not able to successfully download the json data.');
// }
