import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Promodels extends StatefulWidget {
  @override
  _PromodelsState createState() => _PromodelsState();
}

class _PromodelsState extends State<Promodels> {
  SharedPreferences sharedPreferences;

  Future<List> obtenerUsuarios() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var name = sharedPreferences.getString("token");
    final response = await http
        .post("https://breaktalks.com/isf/appconnect/farmerprofile.php", body: {
      "login_id": '$name',
    });
    var data = json.decode(response.body);

    if (sharedPreferences.getString("token") == data[0]['login_id']) {
      setState(() {
        return json.decode(response.body);
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new FutureBuilder<List>(
        future: obtenerUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new farmerprofile(
                  lista: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class farmerprofile extends StatelessWidget {
  final List lista;

  farmerprofile({this.lista});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height / 3,
                    color: Colors.orange[300],
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: EdgeInsets.all(8.0),
                              child: Text(
                                "My Account",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: 100,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CircleAvatar(
                          radius: 50,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          // backgroundImage: NetworkImage(
                          //     'https://breaktalks.com/isf/img/field_officer/' +
                          //         lista[0]['profile_photo']),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.orange[300],
                            size: 80,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            lista[0]['farmer_name'],
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(12.5),
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Aadhar Number",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Text(
                          lista[0]['aadhar'],
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Details",
                          style:
                              TextStyle(color: Color(0xff4749A0), fontSize: 25),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InfoTile(
                            title: "Father's Name",
                            value: lista[0]['fathers_name']),
                        Divider(),
                        InfoTile(title: "Address", value: lista[0]['address']),
                        Divider(),
                        InfoTile(title: "Gender", value: lista[0]['gender']),
                        Divider(),
                        InfoTile(title: "DOB", value: lista[0]['dob']),
                        Divider(),
                        InfoTile(
                            title: "Account Number",
                            value: lista[0]['account_number']),
                        Divider(),
                        InfoTile(
                            title: "Mobile Number", value: lista[0]['mobile']),
                        Divider(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoTile({String title, String value}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
