import 'package:apps/model/invester_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class DetailPortfolio extends StatefulWidget {
  final InvesterPortFolio investerPortFolio;
  DetailPortfolio({this.investerPortFolio});
  @override
  _DetailPortfolioState createState() => _DetailPortfolioState();
}

class _DetailPortfolioState extends State<DetailPortfolio> {
  Widget row(String one, String two) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Container(
            child: Text(one,
                textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
            width: 130),
        Text(' : '),
        Expanded(
            child: Text(two,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Investment Details", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Container(
                        height: 150,
                        width: 150,
                        child: LiquidCircularProgressIndicator(
                          value: double.parse(widget
                                  .investerPortFolio.totalAmountInvested
                                  .toString()) /
                              10000,
                          valueColor: AlwaysStoppedAnimation(Colors.orange),
                          backgroundColor: Color(0xfff3e6e3),
                          borderColor: Color(0xfff3e6e3),
                          borderWidth: 5.0,
                          direction: Axis.vertical,
                          center: Text(
                            "₹${widget.investerPortFolio.totalAmountInvested.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                              "Invested \n₹${widget.investerPortFolio.totalAmountInvested.toString()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Divider(indent: 30, endIndent: 30, thickness: 1),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Information",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      row(' Time Stamp ',
                          ' ${widget.investerPortFolio.timestamp.toString().toUpperCase()}'),
                      Divider(),
                      row(' Return Amount ',
                          ' ₹${widget.investerPortFolio.returnProfitAmount.toString().toUpperCase()}'),
                      Divider(),
                      row(' Farm ID ',
                          ' ${widget.investerPortFolio.farmId.toString().toUpperCase()}'),
                      SizedBox(height: 50),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
