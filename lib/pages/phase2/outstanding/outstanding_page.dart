import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money2/money2.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_account.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_operation.dart';
import 'package:navkar_tracker/services/connection.dart';

import 'package:http/http.dart' as http;

import '../../../utils/alerts.dart';
import '../../../utils/app_properties.dart';

import '../../dashboards/dashboard_admin.dart';
import 'aeging_outstanding_page.dart';
import 'overall_outstanding_page.dart';
import 'team_outstanding_page.dart';
import 'package:navkar_tracker/globalVariables.dart'as globals;

class OutStandingPage extends StatefulWidget {
  @override
  _OutStandingPageState createState() => _OutStandingPageState();
}

class _OutStandingPageState extends State<OutStandingPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  String totalICD, totalCFS;
  int total;
  Money costPrice;

  getData() async{
    var response = await http.get(Uri.parse(Connection.totalOutIcd));
    var result = json.decode(response.body);
    var response1 = await http.get(Uri.parse(Connection.totalOutCfs));
    var result1 = json.decode(response1.body);
    print("${result['outstandings']['Outstanding']}  ${result1['outstandings']['Outstanding']}");
    setState(() {
      totalICD = result['outstandings']['Outstanding'];
      totalCFS = result1['outstandings']['Outstanding'];
      // total = int.parse(totalICD.replaceAll(",", "")) + int.parse(totalCFS.replaceAll(",", ""));
      total = int.parse(totalICD.replaceAll(",", ""));
      print("total outstanding $totalICD $totalCFS $total");
      final usd = Currency.create('IND',0);
      costPrice = Money.fromIntWithCurrency(total, usd);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(globals.Role == "Admin"){
          Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
        }
        if(globals.Role == "Accounts"){
          Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
        }
        if(globals.Role == "Operations"){
          Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
        }
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
        return;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: _appBar(),
        body: dashboard(),
      ),
    );
  }

  Widget _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          if(globals.Role == "Admin"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
          }
          if(globals.Role == "Accounts"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
          }
          if(globals.Role == "Operations"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
          }
         // Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
        },),
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Text("Outstanding",
        style: headingBar,),
      actions: [
        IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              Alerts.showLogOut(context, "LogOut", "Are you sure?");
            }),
      ],
    );
  }

  Widget dashboard(){
    return Container(
     // height: (MediaQuery.of(context).size.width - 30) * (8 / 16),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 105,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(8),
              ),
              width: MediaQuery.of(context).size.width - 30,
              child: totalICD == null && totalCFS == null && total == null ? CircularProgressIndicator() :  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,))
                        ),
                        Text("${costPrice.format("#,##,###")}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,))
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ICD",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,))
                        ),
                        Text("$totalICD",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,))
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text("CFS",
                  //           textAlign: TextAlign.center,
                  //           style: GoogleFonts.montserrat(
                  //               textStyle: TextStyle(
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.black,))
                  //       ),
                  //       Text("$totalCFS",
                  //           textAlign: TextAlign.center,
                  //           style: GoogleFonts.montserrat(
                  //               textStyle: TextStyle(
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.black,))
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => AegingOutStandingPage()));
              },
              child: creditCard(
                text: 'Ageing Outstanding',
                backgroundColor: Colors.deepOrangeAccent.shade200,
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => TeamOutstandingPage()));
              },
              child: creditCard(
                text: 'KDM/Team Outstanding',
                backgroundColor: Colors.lightBlueAccent.shade200,
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => OverallOutstandingPage()));
              },
              child: creditCard(
                text: 'Overall Outstanding',
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget creditCard({String text, Color backgroundColor}) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/money.svg", height: 60, width: 60,),
          SizedBox(height: 20,),
          Text(text,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,))),
        ],
      ),
    );
  }

}

