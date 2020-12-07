import 'package:apps/model/notification.dart';
import 'package:flutter/material.dart';

class DetailNotification extends StatelessWidget {
  final NotificationData notiInfo;
  DetailNotification({this.notiInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("${notiInfo.title}", style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: ListView(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${notiInfo.id}",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                int.parse(notiInfo.status) != 0
                    ? Text(
                        "Active",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Not Active",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              border: TableBorder.all(width: 2.0, color: Colors.black),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Title",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("NOT${notiInfo.title}",
                        style: TextStyle(fontSize: 18)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Notificaton ID",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ID: ${notiInfo.id}",
                        style: TextStyle(fontSize: 18)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Description",
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.black54)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${notiInfo.description}",
                        style: TextStyle(fontSize: 18)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Image",
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.black54)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${notiInfo.image}",
                        textScaleFactor: 1.5, style: TextStyle(fontSize: 15)),
                  ),
                ]),
              ],
            ),
          )
        ]));
  }
}
