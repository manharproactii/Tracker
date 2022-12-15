import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:navkar_tracker/pages/dashboards/dashboard_account.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_operation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboards/dashboard_admin.dart';
import '../../services/connection.dart';
import '../../utils/alerts.dart';
import '../../utils/app_properties.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/validator.dart';
import 'package:navkar_tracker/globalVariables.dart' as globals;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validator{

  bool remember = false;

  TextEditingController name;
  TextEditingController pass;
  AutovalidateMode _autovalidateMode = AutovalidateMode.always;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    name = new TextEditingController();
    pass = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Container(
        alignment: Alignment.center,
        color: bg,
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: _autovalidateMode,
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text("Login", style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
                SizedBox(height: 10,),
                Image.asset("assets/logo_big.png",height: 200,width: 280,),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.deepPurple.shade100,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple[700],

                    ),
                    child: TextFormField(
                      controller: name,
                      validator: validateName,
                      style: TextStyle(
                          color: Colors.purple.shade200,
                          fontSize: 15
                      ),
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "John Kennedy",
                          hintStyle: TextStyle(
                              color: Colors.purple.shade200,
                              fontSize: 15
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.deepPurple.shade100,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple[700],
                    ),
                    child: TextFormField(
                      controller: pass,
                      validator: validateRequired,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                      //keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "•••••••••",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Remember Me",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.deepPurple.shade100,
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                          ),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: remember ?
                        Container(
                          height: 35,
                          width: 35,
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                remember = !remember;
                              });
                              print("remember me true $remember");
                            },
                            icon: Icon(Icons.check,
                              color: Colors.deepPurple,
                              size: 20,),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple[900],
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                ),
                              ]
                          ),
                        ) :
                        Container(
                          height: 35,
                          width: 35,
                          child: TextButton(
                            onPressed: () async{
                              setState(() {
                                remember = !remember;
                              });
                              print("remember me false $remember");
                            },
                            child: null
                          ),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.shade200,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple[900],
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                ),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 40),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 70,
                      width: 70,
                      child: IconButton(
                        onPressed: (){
                          print("object values ${name.text} ${pass.text}");
                          _getUser();
                        },
                        icon: Icon(Icons.arrow_forward_outlined,
                          color: purple,
                          size: 35,),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade200,
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                          ]
                      ),
                    ),

                  ),
                ),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Align(
              // alignment: Alignment.centerLeft,
              child: Text("Powered by",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.deepPurple.shade100,
                    fontSize: 10,
                    fontWeight: FontWeight.w400
                ),),
            ),
          ),
          SizedBox(height: 5,),
          Container(
              color: bg,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Image.asset("assets/adani_logo.png",height: 80,width: 80,),
              )),
        ],
      ),
    );
  }

  _getUser() async {
    if (_formkey.currentState.validate()){
      _formkey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      print("Connection.login URL========== ${Connection.login}");
      print("name.text ========== ${name.text}");
      print("pass.text========== ${pass.text}");
      var response = await http.post(Uri.parse(Connection.login), body: {
      'LoginID':name.text,
      'Password':pass.text
      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['UserID'] != null) {
        
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('UserID', results['UserID']);
        preferences.setString('EmpID', results['EmpID']);
        preferences.setString('UserName', results['UserName']);
        preferences.setString('UserType', results['UserType']);
        preferences.setString('DeptType', results['DeptType']);
        preferences.setString('ConCode', results['ConCode']);
        preferences.setString('Role', results['Role']);
        preferences.setBool('remember', remember);

        String role = results['Role'];
        print("object role $role");
        globals.Role = role;



        if(role == "Admin"){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardAdmin()), (Route<dynamic> route) => false);
        } else if(role == "Operations"){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardOperation()), (Route<dynamic> route) => false);
        } else if(role == "Accounts"){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardAccount()), (Route<dynamic> route) => false);
        }
      } else {
        Alerts.showAlertAndBack(context, "Login Failed", "Incorrect Name or Password");
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }

  }

}
