import 'package:flutter/material.dart';

class LogoutOverlay extends StatefulWidget {
  final String message;
  LogoutOverlay({this.message});
  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: Colors.orange[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "${widget.message}",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: ButtonTheme(
                          height: 35.0,
                          minWidth: 110.0,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            splashColor: Colors.white.withAlpha(40),
                            child: Text(
                              'Ok',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.orange[200],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ))),
                ],
              )),
        ),
      ),
    );
  }
}
