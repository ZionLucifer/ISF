import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:apps/model/harvest.dart';

class DetailHarvesting extends StatefulWidget {
  final HarvestingList harvestInfo;
  final String userid;
  DetailHarvesting({this.harvestInfo, @required this.userid});
  @override
  _DetailHarvestingState createState() => _DetailHarvestingState();
}

class _DetailHarvestingState extends State<DetailHarvesting> {
  @override
  void initState() {
    super.initState();
    showImageUrl();
  }

  String image, sign;

  void showImageUrl() async {
    var data = jsonDecode(widget.harvestInfo.bills) as List;

    try {
      if (data[0].toString() == "" || data[1].toString() == "") {
        if (data[0].toString() == "") {
          setState(() {
            image =
                "https://i1.wp.com/saedx.com/blog/wp-content/uploads/2019/01/saedx-blog-featured-70.jpg?fit=1200%2C500&ssl=1";
          });
        }
        if (data[1].toString() == "") {
          setState(() {
            sign =
                "https://i1.wp.com/saedx.com/blog/wp-content/uploads/2019/01/saedx-blog-featured-70.jpg?fit=1200%2C500&ssl=1";
          });
        }
      } else {
        setState(() {
          image = "http://isf.breaktalks.com/appconnect/" +
              data[0].toString().substring(1);
          sign = "http://isf.breaktalks.com/appconnect/" +
              data[1].toString().substring(1);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget table(String one, String two, {int maxline}) {
    return TextField(
      enabled: false,
      style: TextStyle(color: Colors.black, fontSize: 19),
      controller: TextEditingController(text: '   $two'),
      maxLines: maxline ?? 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
        labelText: one,
        labelStyle: TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  TableRow row(String one, String two) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(one,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(two, style: TextStyle(fontSize: 18)),
      )
    ]);
  }

  void updateendharvest() async {
    http.Response res = await http.post(
      'http://isf.breaktalks.com/appconnect/updateharvesting.php',
      body: {
        'field_officer_id': widget.userid.trim().toString(),
        'farm_id': widget.harvestInfo.farmId.trim().toString(),
        'harvest_id': widget.harvestInfo.harvestId.trim().toString(),
        'end_date': DateTime.now().toString().trim(),
      },
    );
    print('${res.statusCode}>>${res.body}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.harvestInfo.status );
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.harvestInfo.harvestId}",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ID: ${widget.harvestInfo.id}",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
                Text(
                  "Farm ID: ${widget.harvestInfo.farmId}",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                )
              ],
            ),
          ),
          Divider(thickness: 1.5),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            child: Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: [
                row('Details', '${widget.harvestInfo.details}'),
                row('Time', '${widget.harvestInfo.timestamp}'),
                row('No. of Units', '${widget.harvestInfo.noOfUnits}'),
                row('Cost Per Unit', '${widget.harvestInfo.unitCost}'),
              ],
              border: TableBorder.all(width: 1.5),
            ),
          )
        ],
      ),
      floatingActionButton: (widget.harvestInfo.status.toString() == '0')
          ? null
          : FloatingActionButton.extended(
              label: Text('End Harvest'),
              onPressed: updateendharvest,
              backgroundColor: Colors.orange),
    );
  }
}
