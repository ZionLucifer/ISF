import 'package:apps/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class DetailRecordExpense extends StatefulWidget {
  final ExpenseList expenseList;
  DetailRecordExpense({this.expenseList});
  @override
  _DetailRecordExpenseState createState() => _DetailRecordExpenseState();
}

class _DetailRecordExpenseState extends State<DetailRecordExpense> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.expenseList.subtot}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.expenseList.fundRequestId}",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "ID: ${widget.expenseList.farmExpenseId}",
                  style: TextStyle(fontSize: 17.0, color: Colors.black),
                ),
                widget.expenseList.approvedStatus.toString() == '0'
                    ? Text(
                  "Approved",
                  style: TextStyle(fontSize: 17.0, color: Colors.green),
                )
                    : Text(
                  "Pending",
                  style: TextStyle(fontSize: 17.0, color: Colors.red),
                )
              ],
            ),
          ),
          Container(
            color: Colors.orange[100],
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Center(
                    child: Text(
                      widget.expenseList.subtot.toString() != ""
                          ? "Subtotal: ₹${widget.expenseList.subtot.toString().toUpperCase()}"
                          : "N/A",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  height: 100,
                  width: 100,
                  child: LiquidCircularProgressIndicator(
                    value: widget.expenseList.subtot.toString() != ""
                        ? double.parse(widget.expenseList.subtot.toString()) /
                        1000
                        : .5, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(Colors
                        .orange), // Defaults to the current Theme's accentColor.
                    backgroundColor: Color(
                        0xfff3e6e3), // Defaults to the current Theme's backgroundColor.
                    borderColor: Color(0xfff3e6e3),
                    borderWidth: 5.0,
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: Text(widget.expenseList.subtot.toString() != ""
                        ? "₹${widget.expenseList.subtot.toString().toUpperCase()}"
                        : "N/A"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: 300,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  textDirection: TextDirection.ltr,
                  border:TableBorder.all(width: 1.0,color: Colors.black),
                  children: [
                    TableRow(
                        children: [
                          SizedBox(
                            width: 10.0,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,top:12.0),
                              child: Text(
                                "Approved",
                                style: TextStyle(fontSize: 19.0,color: Colors.black54),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              "${widget.expenseList.approvedBy}",
                              style: TextStyle(fontSize: 19.0,color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
                    ),

                    TableRow(
                        children: [
                          SizedBox(
                            width: 10.0,
                            height: 50,
                            child:  Padding(
                              padding: const EdgeInsets.only(left:10.0,top: 12.0),
                              child: Text(
                                "Particulars",
                                style: TextStyle(fontSize: 19.0,color: Colors.black54),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              "${widget.expenseList.particulars}",
                              maxLines: 5,
                              style: TextStyle(fontSize: 19.0,color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          SizedBox(
                            width: 10.0,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(left:10.0,top: 70.0),
                              child: Text(
                                "Purpose",
                                style: TextStyle(fontSize: 19.0,color: Colors.black54),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text(
                              "${widget.expenseList.purpose}",
                              maxLines: 10,
                              style: TextStyle(fontSize: 19.0,color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
                    )
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}