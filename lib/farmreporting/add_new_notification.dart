import 'dart:convert';
import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
// import 'package:audio_picker/audio_picker.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/Image/PickImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddNewNotification extends StatefulWidget {
  final Overview farmInfo;
  AddNewNotification({this.farmInfo});
  @override
  _AddNewNotificationState createState() => _AddNewNotificationState();
}

class _AddNewNotificationState extends State<AddNewNotification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  File _image;
  String _absolutePathOfAudio;
  AudioPlayer audioPlayer;
  // final picker = ImagePicker();
  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file, fit: BoxFit.contain),
    );
  }

  Future getImage() async {
    // final image = await picker.getImage(source: ImageSource.camera);
    String ipath = await ImageUtils.getimage(context);


    if (ipath == null) {
      print("No Image was Picked");
    }
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/record.png');
    setState(() {
      _image = fileImage;
    });
  }


  _sendData(file) async {
    var request = http.MultipartRequest('POST',
        Uri.parse("http://isf.breaktalks.com/appconnect/addnotification.php"))
      ..fields['field_officer_id'] = userId
      ..fields['notification_id'] = ''
      ..fields['farm_id'] = widget.farmInfo.farmId
      ..fields['title'] = titleController.text.toString()
      ..fields['description'] = descriptionController.text.toString()
      ..files.add(await http.MultipartFile.fromPath('files', file));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded");
      print(response.reasonPhrase);
      print(response.request);
    } else {
      print("${response.statusCode}");
    }
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
        print("Test Else");
        print(userId);
        print(mobile);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    audioPlayer = AudioPlayer();
  }
  void showLoading() {
    showDialog(
      context: navigatorKey.currentState.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Loading"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dismissLoading() {
    Navigator.pop(navigatorKey.currentState.overlay.context);
  }

  void openAudioPicker() async {
    showLoading();
    var path = await AudioPicker.pickAudio();
    dismissLoading();
    setState(() {
      _absolutePathOfAudio = path;
    });
  }

  void playMusic() async {
    await audioPlayer.play(_absolutePathOfAudio, isLocal: true);
  }

  void stopMusic() async {
    await audioPlayer.stop();
  }

  void resumeMusic() async {
    await audioPlayer.resume(); // quickly plays the sound, will not release
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Add New Notification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Text(
                    "ADD NEW NOTIFICATION TO INVESTOR ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5)),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: titleController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter The Title",
                        hintStyle:
                            TextStyle(fontSize: 17.0, color: Colors.black45),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: descriptionController,
                    cursorColor: Colors.orange,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                      hintStyle:
                          TextStyle(fontSize: 17.0, color: Colors.black45),
                    ),
                  ),
                ),
                 SizedBox(height: 20),
                Container(

                   child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.orange,
                child: Text(
                  "Select an audio",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  openAudioPicker();
                },
              ),
              _absolutePathOfAudio == null
                  ? Container()
                  : Text(
                      "Absolute path",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        new ClipboardData(text: _absolutePathOfAudio));
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Copied path !')),
                    );
                  },
                  child: _absolutePathOfAudio == null
                      ? Container()
                      : Text(_absolutePathOfAudio),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _absolutePathOfAudio == null
                      ? Container()
                      : FlatButton(
                          color: Colors.green[400],
                          child: Text(
                            "Play",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: playMusic,
                        ),
                  _absolutePathOfAudio == null
                      ? Container()
                      : FlatButton(
                          color: Colors.red[400],
                          child: Text(
                            "Stop",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: stopMusic,
                        )
                ],
              ),
            ],
          ),
        ),
                  // width: double.infinity,
                  // padding: const EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //     color: Colors.orange[300],
                  //     borderRadius: BorderRadius.circular(10.0)),
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   // crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Center(
                  //         child: FlatButton(
                  //           onPressed: () {
                  //              openAudioPicker();
                  //           },
                  //           child: Icon(Icons.mic_rounded,
                  //               color: Colors.white, size: 50),
                  //         ),
                  //       ),
                  //     ),
                  //     // Expanded(
                  //     //   flex: 1,
                  //     //   child: FlatButton(
                  //     //     onPressed: () {},
                  //     //     child: Icon(Icons.play_circle_fill_outlined,
                  //     //         color: Colors.white, size: 50),
                  //     //   ),
                  //     // ),
                  //     // Expanded(
                  //     //   flex: 1,
                  //     //   child: FlatButton(
                  //     //     onPressed: () {},
                  //     //     child: Icon(Icons.pause,
                  //     //         color: Colors.white, size: 50),
                  //     //   ),
                  //     // ),
                  //        Expanded(
                  //       flex: 1,
                  //       child: Center(
                  //         child: FlatButton(
                  //           onPressed: () {},
                  //           child: Icon(Icons.autorenew,
                  //               color: Colors.white, size: 50),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 4,
                  //       child: Center(
                  //         child: Text('Audio File.mp3',style: TextStyle(color: Colors.white,fontSize: 20),),
                  //       ),
                  //     ),
                  //   ],
                  // ),
          

                SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: _image == null
                        ? FlatButton(
                            onPressed: () {
                              getImage();
                            },
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : Column(
                            children: [
                              displaySelectedFile(_image),
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Text("Retake"))
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: RaisedButton(
                        child: Text("ADD NEW NOTIFICATION",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Colors.orange[300],
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty) {
                            _sendData(_image.path);
                            print(base64);
                            setState(() {
                              _image = null;
                              titleController.clear();
                              descriptionController.clear();
                            });
                            showDialog(
                                context: context,
                                builder: (context) => LogoutOverlay(
                                    message: "Data Updated Successfully"));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => LogoutOverlay(
                                    message: "Please Add all the fields"));
                          }
                        }))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
class AudioPicker {
  static const MethodChannel _channel = const MethodChannel('audio_picker');

  static Future<String> pickAudio() async {
    final String absolutePath = await _channel.invokeMethod('pick_audio');
    return absolutePath;
  }
}

