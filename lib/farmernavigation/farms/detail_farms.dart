import 'package:apps/fieldofficernavigation/widgets/home_slider.dart';
import 'package:apps/model/farmer_get_all_farms.dart';
import 'package:flutter/material.dart';

class DetailFarms extends StatefulWidget {
  final FarmerGetAllFarms farmerGetAllFarms;
  DetailFarms({this.farmerGetAllFarms});
  @override
  _DetailFarmsState createState() => _DetailFarmsState();
}

class _DetailFarmsState extends State<DetailFarms> {
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
                                child: Text("Acerage: " +
                                            widget.farmerGetAllFarms.acerage
                                                .toString() !=
                                        ""
                                    ? "${widget.farmerGetAllFarms.acerage.toString()}"
                                    : "N/A"),
                              ),
                              Container(
                                child: Text("Base Location: " +
                                            widget
                                                .farmerGetAllFarms.baseLocation
                                                .toString() !=
                                        ""
                                    ? "${widget.farmerGetAllFarms.baseLocation.toString().toUpperCase()}"
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
                                  "Description",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.farmerGetAllFarms.description
                                            .toString() !=
                                        ""
                                    ? "${widget.farmerGetAllFarms.description.toString().toUpperCase()}"
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
                                  "Crops",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.farmerGetAllFarms.description
                                            .toString() !=
                                        ""
                                    ? "${widget.farmerGetAllFarms.crops.toString().toUpperCase()}"
                                    : "N/A"),
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
