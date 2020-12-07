import 'package:flutter/material.dart';
import 'package:apps/dashboard.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmingly',
      theme: ThemeData(
          primarySwatch: Colors.orange, accentColor: Colors.orange[300]),
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}

// Todo: Dashboard grid length
