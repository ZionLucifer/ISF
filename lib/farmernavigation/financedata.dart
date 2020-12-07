import 'package:flutter/material.dart';
import 'package:apps/farmernavigation/finance.dart';

class financeData extends StatefulWidget {
  final PaymentModel payment;

  const financeData({Key key, this.payment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _financeDataState();
}

class _financeDataState extends State<financeData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.payment.fundid,
                  style: TextStyle(
                      inherit: true,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      fontFamily: 'JosefinSans'),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(widget.payment.totalloan,
                      style: TextStyle(
                          fontFamily: 'JosefinSans',
                          inherit: true,
                          fontSize: 8.0,
                          color: Colors.black)),
                  Text(widget.payment.totalexp,
                      style: TextStyle(
                          fontFamily: 'JosefinSans',
                          inherit: true,
                          fontSize: 8.0,
                          color: Colors.black)),
                  Text(widget.payment.balance,
                      style: TextStyle(
                          fontFamily: 'JosefinSans',
                          inherit: true,
                          fontSize: 8.0,
                          color: Colors.black)),
                ],
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
