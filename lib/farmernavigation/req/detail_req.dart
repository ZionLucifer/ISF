import 'package:apps/fieldofficernavigation/widgets/home_slider.dart';
import 'package:apps/model/farmer_fund_req.dart';
import 'package:flutter/material.dart';

class DetailReq extends StatefulWidget {
  final FarmerFundReq farmerFundReq;
  DetailReq({this.farmerFundReq});
  @override
  _DetailReqState createState() => _DetailReqState();
}

class _DetailReqState extends State<DetailReq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            flexibleSpace: HomeSlider(),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 200,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text("Amount: " +
                                            widget.farmerFundReq.amount
                                                .toString() !=
                                        ""
                                    ? "₹${widget.farmerFundReq.amount.toString()}"
                                    : "N/A"),
                              ),
                              Container(
                                child: Text("Base Location: " +
                                            widget.farmerFundReq.investerId
                                                .toString() !=
                                        ""
                                    ? "${widget.farmerFundReq.investerId.toString().toUpperCase()}"
                                    : "N/A"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Fund Request ID",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.farmerFundReq.fundRequestId
                                            .toString() !=
                                        ""
                                    ? "${widget.farmerFundReq.fundRequestId.toString().toUpperCase()}"
                                    : "N/A"),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Approved Status",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.farmerFundReq.approvedStatus
                                            .toString() ==
                                        '0'
                                            ""
                                    ? "Active"
                                    : "Not Active"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                childCount: 1),
          )
        ],
      )),
    );
  }
}
