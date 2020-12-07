import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FarmerEditProfilePage extends StatefulWidget {
  @override
  _FarmerEditProfilePageState createState() => _FarmerEditProfilePageState();
}

class _FarmerEditProfilePageState extends State<FarmerEditProfilePage> {
  String _date = "Select A Date";
  List<String> _gender = ["Male", "Female", "Rather Not Say"]; // Option 2
  String _selectedGender;
  TextEditingController nameController = new TextEditingController();
  TextEditingController fatherNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController accountNumberController = new TextEditingController();
  TextEditingController aadharNumberController = new TextEditingController();
  TextEditingController panNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();

  // ignore: unused_element
  _resetController() {
    setState(() {
      nameController.clear();
      fatherNameController.clear();
      addressController.clear();
      accountNumberController.clear();
      aadharNumberController.clear();
      panNumberController.clear();
      emailController.clear();
      phoneNumberController.clear();
      // _selectedGender = "";
      // _date = "Select A Date";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.orange[300],
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 30, left: 20, right: 30, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 40,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.white,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.save,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    print("Save Button Pressed in Header");
                                  })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 1.25,
                      padding: EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0))),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                "Personel Info",
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.w500),
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.orange[200],
                                radius: 50,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      print("Image");
                                    }),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: nameController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Name",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: fatherNameController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Father/Husband's Name",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              // height: 50,
                              child: TextField(
                                controller: addressController,
                                maxLines: 3,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Address",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(_date),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(1970, 1, 1),
                                              maxTime: DateTime(2022, 12, 31),
                                              onConfirm: (date) {
                                            print('confirm $date');
                                            setState(() {
                                              _date =
                                                  '${date.year} - ${date.month} - ${date.day}';
                                            });
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en);
                                          print(_date);
                                        })
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: DropdownButton(
                                hint: Text(
                                    "Gender"), // Not necessary for Option 1
                                value: _selectedGender,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                                items: _gender.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: accountNumberController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.numberWithOptions(),
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Account Number",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: aadharNumberController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.numberWithOptions(),
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Aadhar Number",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: panNumberController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization:
                                    TextCapitalization.characters,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Pan Number",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: emailController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Email",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.orange[100],
                                primaryColorDark: Colors.orange[300]),
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: phoneNumberController,
                                cursorColor: Colors.orange[300],
                                keyboardType: TextInputType.numberWithOptions(),
                                autocorrect: false,
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  labelText: "Phone Number",
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 5,
                            thickness: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      print("Save Button Pressed");
                                    },
                                    child: Text(
                                      "Save",
                                      style:
                                          TextStyle(color: Colors.lightGreen),
                                    )),
                                SizedBox(
                                  width: 3.0,
                                ),
                                FlatButton(
                                    onPressed: () {
                                      print("Reset Button Pressed");
                                      _resetController();
                                    },
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(color: Colors.red[300]),
                                    ))
                              ],
                            ),
                          ),
                          Divider()
                        ],
                      ))
                ],
              ),
            )));
  }
}
