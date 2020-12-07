import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';
import 'package:geolocator/geolocator.dart';

class GooMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  GooMap({this.longitude, this.latitude});

  @override
  _GooMapState createState() => _GooMapState();
}

class _GooMapState extends State<GooMap> {
  LatLng _locationData;
  Set<Polygon> _polygons = HashSet<Polygon>();
  List<LatLng> polygonLatLngs = List<LatLng>();
  int _polygonIdCounter = 1;

  @override
  void initState() {
    super.initState();
  }

  Position position;

  Future getLocation() async {
    if (widget.latitude == null || widget.longitude == null) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _locationData = LatLng(position.latitude, position.longitude);
    } else {
      _locationData = LatLng(widget.latitude, widget.longitude);
    }
    Future.delayed(Duration(microseconds: 100), () {
      showinfo();
    });
  }

  // Draw Polygon to the map
  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    ));
  }

  Widget _fabPolygon() {
    return FloatingActionButton.extended(
      heroTag: '1',
      onPressed: () {
        setState(() {
          polygonLatLngs.removeLast();
        });
      },
      icon: Icon(Icons.undo),
      label: Text('Undo point'),
      backgroundColor: Colors.orange,
    );
  }

  Widget _fabsave() {
    return FloatingActionButton.extended(
      heroTag: '0',
      onPressed: () {
        Navigator.of(context).pop(_polygons);
      },
      icon: Icon(Icons.save, color: Colors.white),
      label: Text('Save', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    );
  }

  void showinfo() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: FittedBox(child: Text('Select Boundries of Farm ')),
        content: Text(
            '* Click on Centre point of the farm\n' +
                '* Click on the boundaries of the farm in order\n' +
                '* Once marking boundary verify and click save button',
            textAlign: TextAlign.left),
        actions: [
          RaisedButton(
            color: Colors.orange,
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.orange,
        title: Text(
          'Select Farm Boundries',
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: 30),
          polygonLatLngs.length > 0 ? _fabPolygon() : SizedBox.shrink(),
          Spacer(),
          _fabsave()
        ],
      ),
      body: FutureBuilder(
        future: getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return body();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget body() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(_locationData.latitude, _locationData.longitude),
              zoom: 16),
          mapType: MapType.hybrid,
          polygons: _polygons,
          myLocationEnabled: true,
          onTap: (point) {
            setState(() {
              polygonLatLngs.add(point);
              _setPolygon();
            });
          },
        ),
      ],
    );
  }
}
