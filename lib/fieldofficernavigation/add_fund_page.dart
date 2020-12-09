import 'package:apps/components/logout_overlay.dart';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFundPage extends StatefulWidget {
  AddFundPage({this.farmInfo});
  final Overview farmInfo;

  @override
  _AddFundPageState createState() => _AddFundPageState();
}

class _AddFundPageState extends State<AddFundPage> {
  TextEditingController amountController = new TextEditingController();
  TextEditingController purposeController = new TextEditingController();
  TextEditingController amountnoCont = new TextEditingController();
  TextEditingController accnamecont = new TextEditingController();
  TextEditingController mobilenocont = new TextEditingController();
  TextEditingController ifsccont = new TextEditingController();
  SharedPreferences sharedPreferences;
  String userId, mobile;
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

  Future _sendFunds() async {
    try {
      if (userId == null) await _getData();
      var response = await http.post(
        "http://isf.breaktalks.com/appconnect/generalfundrequest.php",
        body: {
          "field_officer_id": userId,
          "purpose": purposeController.text.toString(),
          "amount": amountController.text.toString(),
          "mobile": mobilenocont.text.toString(), //
          "account_number": amountnoCont.text.toString(), //
          "account_name": accnamecont.text.toString(), //
          "ifsc_code": ifsccont.text.toString(), //
        },
        headers: {'Accept': 'application/json'},
      );
      print('Status Code :: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('response :: ${response.body}');
      } else {
        print('response :: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  void save() {
    bool istrue = _key.currentState.validate();
    if (istrue) {
      _sendFunds();
      setState(() {
        amountController.clear();
        purposeController.clear();
        mobilenocont.clear();
        amountnoCont.clear();
        accnamecont.clear();
        ifsccont.clear();
      });
      showDialog(
          context: context,
          builder: (_) => LogoutOverlay(message: "Added Funds"));
    } else {
      return null;
      // showDialog(
      //     context: context,
      //     builder: (_) => LogoutOverlay(message: "Enter All fields"));
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
    // print(widget.farmInfo.farmId);
  }

  Widget formfield(String text, bool optional, TextEditingController control,
      [TextInputType keyboardType, int maxword, int id]) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        validator: (val) {
          if ( optional || id == 2 && val.contains(new RegExp('[0-9]'))){
            return 'Invalid Account Name';
          }else if(optional && id ==3 ){
           return null;
          } else {
            if (val?.isEmpty ?? true) {
              return 'Can\'t Be Empty';
            }else
            if( id == 1 && val.length != maxword){
              return 'Enter Remaining Digits';
            } else {
              return null;

            }
          }
        },
        maxLength: maxword,
        controller: control,
        keyboardType: keyboardType,
        decoration:
        InputDecoration(labelText: text, border: OutlineInputBorder()),
      ),
    );
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Funds", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => fielddash()),
                      (route) => false);
            }),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  formfield('Enter the amount*', false, amountController,
                      TextInputType.numberWithOptions(),null, 0),
                  SizedBox(height: 15),
                  formfield(
                      'Enter the purpose*', false, purposeController, TextInputType.text,null,0),
                  SizedBox(height: 15),
                  formfield('Account Name', false, accnamecont,TextInputType.text,null,2),
                  SizedBox(height: 15),
                  formfield('Account Number', false, amountnoCont,
                      TextInputType.numberWithOptions(),null,3),
                  SizedBox(height: 15),
                  formfield('IFSC Code', false, ifsccont,null,null,3),
                  SizedBox(height: 15),
                  formfield('Mobile No', false, mobilenocont,
                      TextInputType.phone,10,1),
                  SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Request Fund', style: TextStyle(color: Colors.white)),
          onPressed: save,
          backgroundColor: Colors.orange),
    );
  }
}
