import 'package:apps/components/logout_overlay.dart';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/pending_requests.dart';
import 'package:apps/fieldofficernavigation/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/Image/PickImage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addfarm.dart';
import '../components/logout_overlay.dart' as ord;

class AndroidMessagesPage extends StatefulWidget {
  @override
  _AndroidMessagesPageState createState() => _AndroidMessagesPageState();
}

class _AndroidMessagesPageState extends State<AndroidMessagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId;
  File imagePath;
  TextEditingController nameController = new TextEditingController();
  TextEditingController fatherNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController accountNameController = new TextEditingController();
  TextEditingController bankNameController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  String mobile, fundRequestId, farmId, purpose, amount, approvedStatus;
  List _fund = [];
  DateTime _dateTime;
  Map fund, expense;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String responseCode;
  String errMessage = 'Error Uploading Image';
  // final picker = ImagePicker();
  File galleryFile;
  bool isGoingDown = true;
  int i = 4;
  File _aadharImage, _panImage;
  String _chosenvalue;
  final _formKey = GlobalKey<FormState>();
  void showloading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('       Uploading Data...')
              ],
            ),
          )),
    );
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

  Future _sendData() async {
    try {
      showloading();
      var request = http.MultipartRequest('POST',
          Uri.parse("http://isf.breaktalks.com/appconnect/addfarmer.php"))
        ..fields['field_officer_id'] = userId
        ..fields['farmer_name'] = nameController.text.toString()
        ..fields['fathers_name'] = fatherNameController.text.toString()
        ..fields['dob'] = "$_dateTime"
        ..fields['gender'] = _chosenvalue
        ..fields['email'] = emailController.text.toString()
        ..fields['mobile'] = mobileController.text.toString()
        ..fields['account_number'] = accountNameController.text.toString()
        ..fields['bank_name'] = bankNameController.text.toString()
        ..fields['ifsc'] = ifscController.text.toString()
        ..files.add(await http.MultipartFile.fromPath(
            'profile_photo', galleryFile.path))
        ..files.add(
            await http.MultipartFile.fromPath('aadhar_img', _aadharImage.path))
        ..files
            .add(await http.MultipartFile.fromPath('pan_img', _panImage.path))
        ..fields['address'] = addressController.text.toString()
        ..fields['pan'] = panController.text.toString()
        ..fields['aadhar'] = aadharController.text.toString()
        ..fields['pincode'] = pincodeController.text.toString();
      var response = await request.send();
      setState(() {
        responseCode = responseCode;
      });
      if (response.statusCode == 200) {
        print("New Farmer Uploaded Sucessfully");
        setState(() {
          panController.clear();
          aadharController.clear();
          ifscController.clear();
          bankNameController.clear();
          accountNameController.clear();
          mobileController.clear();
          emailController.clear();
          genderController.clear();
          dobController.clear();
          fatherNameController.clear();
          nameController.clear();
          addressController.clear();
          galleryFile = null;
          _aadharImage = null;
          _panImage = null;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  void _popup(BuildContext context) {
    i++;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.orange[50],
            title: Text(
              'Alert',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            content: Text(
              'Details Saved Successfully \n Farmerid: FAM010 $i',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => fielddash()));
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.orange[300],
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  Widget displaySelectedFile(File file) {
    return Container(
      child: new CircleAvatar(
        radius: 50,
        backgroundImage: file == null
            ? new Text('Sorry nothing selected!!')
            : new FileImage(file),
      ),
    );
  }

  Future getAadharImage() async {
    // final image =
    //     await picker.getImage(imageQuality: 50, source: ImageSource.camera);
    String path = await ImageUtils.getimage(context);
    setState(() {
      _aadharImage = File(path);
    });
  }

  Future getPanImage() async {
    // final image =
    //     await picker.getImage(imageQuality: 50, source: ImageSource.camera);
    String path = await ImageUtils.getimage(context);
    setState(() {
      _panImage = File(path);
    });
  }

  Widget displayFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(
        file,
        fit: BoxFit.cover,
      ),
    );
  }

  Future imageSelector() async {
    String path = await ImageUtils.getimage(context);
    galleryFile = File(path);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    panController.clear();
    aadharController.clear();
    ifscController.clear();
    bankNameController.clear();
    accountNameController.clear();
    mobileController.clear();
    emailController.clear();
    genderController.clear();
    dobController.clear();
    fatherNameController.clear();
    nameController.clear();
    addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add Farmer",
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => fielddash()),
                    (route) => false);
          },
        ),
        actions: [],
      ),
      body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    galleryFile == null
                                        ? CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.orange[300],
                                      child: IconButton(
                                        onPressed: imageSelector,
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                        : Column(
                                      children: [
                                        displaySelectedFile(galleryFile),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                galleryFile = null;
                                              });
                                              imageSelector();
                                            },
                                            child: Text("Retake"))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: nameController,
                                    decoration: new InputDecoration(
                                      // hintText: 'Farmer Name',
                                      labelText: 'Enter Farmer Name',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }else if(value.contains(new RegExp('[0-9]'))){
                                        return 'Invalid Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                width: double.infinity,
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: fatherNameController,
                                    decoration: new InputDecoration(
                                      // hintText: 'Father/Husband Name',
                                      labelText: 'Enter Father/Husband Name',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }else if(value.contains(new RegExp('[0-9]'))){
                                        return 'Invalid Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: addressController,
                                    decoration: new InputDecoration(
                                      // hintText: 'Address',
                                      labelText: 'Enter Address',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    // autovalidate: true,
                                    controller: pincodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                    decoration: new InputDecoration(
                                      // hintText: 'Pincode',
                                      labelText: 'Enter Pincode',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }else if(value.length != 6 && value.length < 6) {
                                        return "Enter Remaining Digits";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_dateTime == null
                                      ? 'Select your DOB'
                                      : "${DateFormat.yMMMd().format(_dateTime)}"),
                                  IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1940),
                                            lastDate: DateTime.now())
                                            .then((date) {
                                          setState(() {
                                            _dateTime = date;
                                          });
                                        });
                                      })
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 18.0),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _chosenvalue,
                                        hint: Container(
                                          width: 200,
                                          child: TextFormField(
                                              textAlign: TextAlign.start,
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 16.0),
                                                // hintText: 'Select Gender',
                                                labelText: 'Select Gender',
                                                labelStyle: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.black45),
                                                hintStyle: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.black45),
                                                contentPadding:
                                                new EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                border: InputBorder.none,

                                              )),
                                        ),
                                        items: <String>['Male', 'Female', 'Others']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(left: 15.0),
                                                  child: Text(value),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (String value) {
                                          setState(() {
                                            _chosenvalue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      // hintText: 'E-mail',
                                        labelText: 'Enter Email',
                                        labelStyle: TextStyle(
                                            fontSize: 17.0, color: Colors.black45),
                                        hintStyle: TextStyle(
                                            fontSize: 17.0, color: Colors.black45),
                                        contentPadding: new EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      RegExp exp = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                      if (value.isEmpty) {
                                        return "Email Id is Required";
                                      }
                                      if (!exp.hasMatch(value)) {
                                        return "Invalid Email ID";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    // autovalidate: true,
                                    controller: mobileController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    decoration: new InputDecoration(
                                      // hintText: 'Mobile no',
                                      labelText: 'Enter Mobile number',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      if (value.length != 10 || (value.length < 10)){
                                        return "Invalid Mobile No.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: accountNameController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: new InputDecoration(
                                      // hintText: 'Account no',
                                      labelText: 'Enter Account No',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: bankNameController,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      // hintText: 'Bank Name',
                                        labelText: 'Enter Bank Name',
                                        labelStyle: TextStyle(
                                            fontSize: 17.0, color: Colors.black45),
                                        hintStyle: TextStyle(
                                            fontSize: 17.0, color: Colors.black45),
                                        contentPadding: new EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        border: InputBorder.none),

                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }else if(value.contains(new RegExp('[0-9]'))){
                                        return 'Invalid Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: ifscController,
                                    decoration: new InputDecoration(
                                      // hintText: 'IFSC code',
                                      fillColor: Colors.white,
                                      labelText: 'Enter IFSC Code',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(

                                    controller: aadharController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(12)
                                    ],
                                    decoration: new InputDecoration(
                                      // hintText: 'Aadhar No',
                                      fillColor: Colors.white,
                                      labelText: 'Enter Aadhar No',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                    autovalidate: true,
                                    validator: (value) {
                                      RegExp exp = RegExp("[0-9]{12}");
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      if (!exp.hasMatch(value) && value.length != 12 && value.length < 12 ){
                                        return "Invalid Aadhar Card Format";
                                      }else
                                        return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                  color: Colors.orange[300],
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Center(
                                child: _aadharImage == null
                                    ? FlatButton(
                                  onPressed: () {
                                    getAadharImage();
                                  },
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                                    : Column(
                                  children: [
                                    displayFile(_aadharImage),
                                    FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            _aadharImage = null;
                                          });
                                          getAadharImage();
                                        },
                                        child: Text(
                                          "Retake",
                                          style:
                                          TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: 200,
                                  child: new TextFormField(
                                    controller: panController,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: new InputDecoration(
                                      // hintText: 'Pan No',
                                      fillColor: Colors.white,
                                      labelText: 'Enter Pan No',
                                      labelStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.black45),
                                      contentPadding: new EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                    autovalidate: true,
                                    validator: (value) {
                                      RegExp exp = RegExp(
                                          "[A-Z]{5}[0-9]{4}[A-Z]{1}");
                                      if (value.isEmpty) {
                                        return "Cannot leave this Field";
                                      }
                                      if (!exp.hasMatch(value) && value.length != 10) {
                                        return "Invalid PAN Card No.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                  color: Colors.orange[300],
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Center(
                                child: _panImage == null
                                    ? FlatButton(
                                  onPressed: () {
                                    getPanImage();
                                  },
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                                    : Column(
                                  children: [
                                    displayFile(_panImage),
                                    FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            _panImage = null;
                                          });
                                          getPanImage();
                                        },
                                        child: Text(
                                          "Retake",
                                          style:
                                          TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: new InkWell(
                                  onTap: () {
                                    if (_formKey.currentState.validate() &&
                                        _panImage != null &&
                                        _aadharImage != null) {
                                      print("Done clicked");
                                      _sendData().then((value) => showDialog(
                                          context: context,
                                          builder: (_) => LogoutOverlay(
                                            message: "Farmer Added",
                                          )));
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          builder: (_) => LogoutOverlay(
                                            message: "Enter All Fields",
                                          ));
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: Offset(2, 2),
                                              blurRadius: 5,
                                              spreadRadius: 2)
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.orangeAccent,
                                              Color(0xFFFF9100)
                                            ])),
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        )),
                  ],
                )),
          )),
      drawer: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: new Drawer(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => fielddash()));
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
                            "Add Farmer",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.portrait,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPage()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Add Farm",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.filter_frames,
                              color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPages()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Pending Requests",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.list,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingRequests()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Report",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.report, color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportsScreen()));
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
                            _popup(context);
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
        ),
      ),
    );
  }
}
