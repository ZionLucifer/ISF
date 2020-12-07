import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/crops_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomListView extends StatefulWidget {
  final List<CropsModel> spacecrafts;

  CustomListView(this.spacecrafts);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  BuildContext scaffoldContext;
  List<int>  qty= [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Add Funds Page");
    _getData();
    for(int i = 0; i<widget.spacecrafts.length; i++){
      qty.add(1);
    }
  }

  @override
  Widget build(context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: widget.spacecrafts.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(widget.spacecrafts[currentIndex], context,currentIndex);
      },
    );
  }

  Widget createViewItem(CropsModel spacecraft, BuildContext context,int i) {

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
                  child: Image.network(spacecraft.cropsImage,
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
                        spacecraft.cropsName.toString().toUpperCase() != ""
                            ? "${spacecraft.cropsName.toString().toUpperCase()}"
                            : "N/A",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 2.2,
                      ),
                      Text(spacecraft.cropsId.toString().toUpperCase() != ""
                          ? "${spacecraft.cropsId.toString().toUpperCase()}"
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
                  Flexible(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              "₹${spacecraft.price.toString().toUpperCase()} Per Item Per Acre",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      child: Row(
                        children: <Widget>[
                          // decrementButton(qty),
                          // Text(
                          //   '$qty',
                          //   style: TextStyle(fontSize: 18.0),
                          // ),

                          qty[i] != 1
                              ? new IconButton(
                                  icon: new Icon(Icons.remove),
                                  onPressed: () => setState(() => qty[i]--),
                                )
                              : new Container(),
                          Text(qty[i].toString()),
                          new IconButton(
                              icon: new Icon(Icons.add),
                              onPressed: () => setState(() => qty[i]++)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange[300]),
                    child: FlatButton(
                        onPressed: () {
                          http.post(
                              "http://isf.breaktalks.com/appconnect/addCart.php",
                              body: {
                                "invester_id": userId,
                                "crops_name": spacecraft.cropsName.toString(),
                                "quantity": qty[i].toString()
                              }).then((response) {
                            if (response.statusCode == 200) {
                              print("${spacecraft.cropsName} added to Cart");
                              showDialog(
                                  context: context,
                                  builder: (_) => LogoutOverlay(
                                      message:
                                          "${spacecraft.cropsName} Added To cart"));
                            } else {
                              print("${response.body}");
                              showDialog(
                                  context: context,
                                  builder: (_) => LogoutOverlay(
                                      message:
                                          "Error Occurs :: ${response.statusCode.toString()}"));
                            }
                          });
                        },
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// return new ListTile(
//     title: new Card(
//       color: Colors.white,
//       elevation: 4.0,
//       child: new Container(
//         decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
//         padding: EdgeInsets.all(10.0),
//         margin: EdgeInsets.all(10.0),
//         child: Column(
//           children: <Widget>[
//             Padding(
//               child: Image.network(spacecraft.cropsImage),
//               padding: EdgeInsets.only(bottom: 8.0),
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                       child: Text(
//                         spacecraft.cropsName,
//                         style: new TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange,
//                             fontSize: 12,
//                             fontFamily: 'JosefinSans'),
//                       ),
//                       padding: EdgeInsets.all(2.0)),
//                 ]),
//           ],
//         ),
//       ),
//     ),
//     onTap: () {
//       senddata();
//       Scaffold.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.orange[50],
//         content: Text(
//           'Crop Added to Cart',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.orange,
//           ),
//         ),
//         duration: Duration(seconds: 3),
//       ));
//     });
