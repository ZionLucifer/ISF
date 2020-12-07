import 'package:apps/farmernavigation/req/approved_req.dart';
import 'package:apps/farmernavigation/req/pending_req.dart';
import 'package:flutter/material.dart';
import 'package:apps/farmerdashboard.dart';
import 'package:apps/loginpage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'farmupdate.dart';
import 'finance.dart';
import 'myfarms.dart';

class request extends StatefulWidget {
  @override
  _requestState createState() => _requestState();
}

class _requestState extends State<request> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List _pages = [PendingReq(), ApprovedReq()];

  void _popups(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
                  sharedPreferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "My Request",
          textAlign: TextAlign.center,
          style: (TextStyle(
            fontFamily: 'JosefinSans',
            color: Colors.white,
          )),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => farmerdash()));
          },
        ),
        actions: [],
      ),
      body: SafeArea(
          child: Center(
        child: _pages[_currentIndex],
      )),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: _currentIndex == 0 ? Colors.red : Colors.green,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.priority_high),
            title: Text("Pending"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.code),
            title: Text("Approved"),
          ),
        ],
      ),
      drawer: new Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                //print(loginId);
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => farmerdash()));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Color(0xff1D2952),
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Color(0xff1D2952)),
                  ),
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      title: new Text(
                        "My Farm",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(
                        Icons.portrait,
                        color: Color(0xff1D2925),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => myfarms()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "My Messages",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(Icons.person, color: Color(0xff1D2925)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => farmernoti()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "Notifications",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(
                        Icons.notifications,
                        color: Color(0xff1D2925),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => farmernoti()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "Financial Data",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(Icons.message, color: Color(0xff1D2925)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => finance()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "My Requests",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(
                        Icons.format_list_numbered_rtl,
                        color: Color(0xff1D2925),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => request()));
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: new Text("Logout"),
                      leading: Icon(
                        Icons.cancel,
                        color: Colors.red[200],
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _popups(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Powered By Farmingly",
                  style: TextStyle(color: Color(0xff1D2952)),
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentModel {
  IconData _icon;
  String _name, _date, _hour;
  Color _color;
  double _amount;
  int _paymentType;

  PaymentModel(this._icon, this._color, this._name, this._date, this._hour,
      this._amount, this._paymentType);

  String get name => _name;

  String get date => _date;

  String get hour => _hour;

  double get amount => _amount;

  int get type => _paymentType;

  IconData get icon => _icon;

  Color get color => _color;
}

class PaymentCardWidget extends StatefulWidget {
  final PaymentModel payment;

  const PaymentCardWidget({Key key, this.payment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentCardWidgetState();
}

class _PaymentCardWidgetState extends State<PaymentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        dense: true,
        trailing: Text(
          "${widget.payment.type > 0 ? "+" : "-"} \₹ ${widget.payment.amount}",
          style: TextStyle(
              fontFamily: 'JosefinSans',
              inherit: true,
              fontWeight: FontWeight.w700,
              fontSize: 16.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Material(
            elevation: 10,
            shape: CircleBorder(),
            shadowColor: widget.payment.color.withOpacity(0.4),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: widget.payment.color,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Icon(
                  widget.payment.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.payment.name,
              style: TextStyle(
                  fontFamily: 'JosefinSans',
                  inherit: true,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.payment.date,
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      inherit: true,
                      fontSize: 12.0,
                      color: Colors.black45)),
              SizedBox(
                width: 20,
              ),
              Text(widget.payment.hour,
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      inherit: true,
                      fontSize: 12.0,
                      color: Colors.black45)),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
