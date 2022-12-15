import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:navkar_tracker/bloc/collection_bloc.dart';
import 'package:navkar_tracker/models/collection_model.dart';
import 'package:navkar_tracker/models/mark_location.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_account.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_admin.dart';
import 'package:navkar_tracker/pages/dashboards/dashboard_operation.dart';
import 'package:navkar_tracker/pages/phase2/view_summary_page.dart';
import 'package:navkar_tracker/utils/alerts.dart';
import 'package:navkar_tracker/utils/app_properties.dart';
import 'package:navkar_tracker/globalVariables.dart'as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../services/connection.dart';
import '../../services/container_api.dart';
import '../../utils/progress_dialog.dart';

class MarkLocationPage extends StatefulWidget {
  @override
  _MarkLocationPageState createState() => _MarkLocationPageState();
}

class _MarkLocationPageState extends State<MarkLocationPage> {

  final icdBloc = CollectionBloc();
  final cfsBloc = CollectionBloc();

  AsyncSnapshot<CollectionModel> asi, asc;
  final format = DateFormat("yyyy-MM-dd");
  SharedPreferences prefs;
  String role;
  TextEditingController controllerContainerNo = TextEditingController();

  List<MarkLocation> getMarkLocationList = [];
  List<MarkLocation>  getContainerList= [];
  MarkLocation markLocationValue;
  MarkLocation markContainerNoValue;
  var focusNode = FocusNode();
  @override
  initState(){
    super.initState();
    initRole();

    // icdBloc.fetchICDCollection();
    // cfsBloc.fetchCFSCollection();


  }

  @override
  void dispose() {
    super.dispose();
    icdBloc.dispose();
    cfsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      appBar:_appBar(),
      body: _body(),
    );
  }

  Widget _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          FocusManager.instance.primaryFocus?.unfocus();
          // if(globals.Role == "Admin"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
          // }
          // if(globals.Role == "Accounts"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
          // }
          // if(globals.Role == "Operations"){
          //   Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
          // }

          if(role == "Admin"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
          }
          if(role == "Accounts"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAccount()));
          }
          if(role == "Operations"){
            Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardOperation()));
          }
        }
        ,),
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Mark Location",
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

  String selectedValue = "USA";

  List<DropdownMenuItem<MarkLocation>> get dropdownItems{
    List<DropdownMenuItem<MarkLocation>> menuItems = [
      // DropdownMenuItem(child: Text("USA"),value: "USA"),
      // DropdownMenuItem(child: Text("Canada"),value: "Canada"),
      // DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
      // DropdownMenuItem(child: Text("England"),value: "England"),
    ];

    for(int i=0;i<getMarkLocationList.length;i++){
      menuItems.add(DropdownMenuItem(child: Text("${getMarkLocationList[i].locationName}"),value: getMarkLocationList[i]))
      ;
    }
    return menuItems;
  }

  Widget _body(){

    if(getMarkLocationList.isEmpty){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: CircularProgressIndicator()),
      );
    }else{
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              // TextFormField(
              //   // controller: profileController!.mobileTextController,
              //   keyboardType: TextInputType.number,
              //   textInputAction: TextInputAction.next,
              //
              //
              //
              //   // style: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 14)),
              //   cursorColor: bg,
              //   decoration: InputDecoration(
              //       labelStyle: TextStyle(
              //           color: bg,fontSize: 12
              //       ),
              //       // contentPadding: EdgeInsets.only(top:25,left: 15),
              //       hintStyle: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 14)),
              //       hintText: 'Container No',
              //       labelText: 'Container No',
              //       enabledBorder:OutlineInputBorder(
              //         //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //       focusedBorder:OutlineInputBorder(
              //         // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //       errorBorder: OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
              //         // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
              //       ),
              //       focusedErrorBorder :OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
              //         //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
              //       )
              //   ),
              // ),
              // SizedBox(height: 20,),

              Container(
                // padding: EdgeInsets.all(16),
                child: TypeAheadField<MarkLocation>(

                  errorBuilder: (BuildContext context, Object error) {
                    // print("focusNode.hasFocus ==================> ${focusNode.hasFocus}");
                    if(controllerContainerNo.text.isEmpty && focusNode.hasFocus){
                      // return const Padding(
                      //   padding:  EdgeInsets.only(top: 20.0,bottom: 20,left: 15),
                      //   child: Text(
                      //       'Please enter 1 or more characters',
                      //
                      //   ),
                      // );
                    }else{
                      // return Padding(
                      //   padding: EdgeInsets.only(top: 20.0,bottom: 20,left: 15),
                      //   child: Text(
                      //       '$error',
                      //       style: TextStyle(
                      //           color: Theme.of(context).errorColor
                      //       )
                      //   ),
                      // );
                    }

                  }
                      ,

                  noItemsFoundBuilder: (BuildContext context) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20.0,bottom: 20,left: 15),
                      child: Text(
                        'No data found!',

                      ),
                    );
                  }
                  ,
                  hideSuggestionsOnKeyboardHide: false,
                  textFieldConfiguration: TextFieldConfiguration(
                    focusNode: focusNode,
                    controller: controllerContainerNo,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: bg,fontSize: 16
                        ),
                        // contentPadding: EdgeInsets.only(top:25,left: 15),
                        hintStyle: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 14)),
                        hintText: 'Container No',
                        labelText: 'Container No',
                        enabledBorder:OutlineInputBorder(
                          //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder:OutlineInputBorder(
                          // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
                          // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
                        ),
                        focusedErrorBorder :OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
                          //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
                        )
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return UserApi.getUserSuggestions(controllerContainerNo.text);
                  },
                  // suggestionsCallback: UserApi.getUserSuggestions(),
                  itemBuilder: (context, MarkLocation suggestion) {
                    final user = suggestion;

                    return ListTile(
                      title: Text(user.containerNo),
                    );
                  },

                  onSuggestionSelected: (MarkLocation suggestion) {
                    final user = suggestion;
                    controllerContainerNo.text = user.containerNo;
                    markContainerNoValue = user;

                    // ScaffoldMessenger.of(context)
                    //   ..removeCurrentSnackBar()
                    //   ..showSnackBar(SnackBar(
                    //     content: Text('Selected user: ${user.name}'),
                    //   ));
                  },
                ),
              ),
              SizedBox(height: 20,),
              DropdownButtonFormField<MarkLocation>(
                // decoration: InputDecoration(
                //   enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(color: Colors.blue, width: 2),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   border: OutlineInputBorder(
                //     borderSide: BorderSide(color: Colors.blue, width: 2),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   filled: true,
                //   // fillColor: Colors.blueAccent,
                // ),


                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: bg,fontSize: 16
                      ),

                      // contentPadding: EdgeInsets.only(top:25,left: 15),
                      hintStyle: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 14)),
                      hintText: 'Location',
                      labelText: 'Location',
                      enabledBorder:OutlineInputBorder(
                        //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
                        // borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
                      ),
                      focusedErrorBorder :OutlineInputBorder(  borderRadius: BorderRadius.circular(8.0),
                        //borderSide: const BorderSide(color: AppColors.appText1, width: 1.0)
                      )
                  ),
                  // dropdownColor: Colors.blueAccent,
                  value: markLocationValue,
                  onChanged: (MarkLocation newValue) {
                    setState(() {
                      markLocationValue = newValue;
                    });
                  },
                  items: dropdownItems),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  _saveLocation();

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: bg,
                  ),
                  child: Center(child: Text("Save",style: headingBar,)),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  // FocusManager.instance.primaryFocus?.unfocus();
                  // _saveLocation();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewSummaryPage()));

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  child: Center(child: Text("View Summary",style: headingBar,)),
                ),
              ),
              // SizedBox(height: 5,),

            ],
          ),
        ),
      );
    }

  }


  _saveLocation() async {
    if(controllerContainerNo.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Enter Container No",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else if(markContainerNoValue == null){
      Fluttertoast.showToast(
          msg: "Please Select Container No",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else if(markLocationValue == null){
      Fluttertoast.showToast(
          msg: "Please Select Location",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      print("Connection.saveLocation URL========== ${"${Connection.saveLocation}?LocationID=${markLocationValue.locationID}&AddedBy=1&ContainerNo=${controllerContainerNo.text}"}");
      print("markLocationValue.locationID ====================> ${markLocationValue.locationID}");
      print("controllerContainerNo.text ============> ${controllerContainerNo.text}");
      ProgressDialog pr = ProgressDialog(context,
        isDismissible: true,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      await pr.show();
      var response = await http.post(Uri.parse("${Connection.saveLocation}?LocationID=${markLocationValue.locationID}&AddedBy=1&ContainerNo=${controllerContainerNo.text}"));
      var results = json.decode(response.body);
      print('response == $results ');
      pr.hide();
      if(response.statusCode == 200){

        setState(() {
          controllerContainerNo.clear();
          markContainerNoValue = MarkLocation();
          markLocationValue = null;
          focusNode.requestFocus();
        });

        Fluttertoast.showToast(
            msg: results["Messege"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }else{
        Fluttertoast.showToast(
            msg: results["Messege"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }



    }



  }

  _getLocation() async {
    print("Connection.getLocation URL========== ${Connection.getLocation}");
    var response = await http.get(Uri.parse(Connection.getLocation));
    // var results = json.decode(response.body);
    var result = json.decode(response.body);
    print('response == $result  ${response.body}');

    MarkLocationModel markLocationModel;
    markLocationModel = (MarkLocationModel.fromJson(result));

    // MarkLocationModel markLocationModel = MarkLocationModel.fromJson(results);
    setState(() {
      getMarkLocationList = markLocationModel.markLocation;
      print("getMarkLocationList  ===============> ${getMarkLocationList.length}");
    });



  }

  _getContainerNo() async {
    print("Connection.getLocation URL========== ${Connection.getSearchContainer+"?ContainerNo=A"}");
    var response = await http.get(Uri.parse(Connection.getSearchContainer+"?ContainerNo=A"));
    // var results = json.decode(response.body);
    var result = json.decode(response.body);
    print('response == $result  ${response.body}');

    MarkLocationModel markLocationModel;
    markLocationModel = (MarkLocationModel.fromJson(result));

    // MarkLocationModel markLocationModel = MarkLocationModel.fromJson(results);
    setState(() {
      getContainerList = markLocationModel.markLocation;
      print("getContainerList  ===============> ${getContainerList.length}");
    });



  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
      ),
      child: Text("${asi.data.collection[index].display}", style: content1,
        textAlign: TextAlign.center,),
      //width: 100,
      //height: 52,
      //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Container(
      color: Colors.black,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].cash}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].cheque}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].dd}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].rtgs}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.collection[index].total}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow1(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
      ),
      child: Text("${asc.data.collection[index].display}", style: content1,
        textAlign: TextAlign.center,),
      //width: 100,
      //height: 52,
      //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow1(BuildContext context, int index) {
    return Container(
      color: Colors.black,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].cash}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].cheque}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].dd}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].rtgs}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asc.data.collection[index].total}", style: content1,
                textAlign: TextAlign.center,),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initRole() async {
    prefs = await SharedPreferences.getInstance();
    role = prefs.getString('Role');
    print("object role $role");
    _getLocation();
    _getContainerNo();
    focusNode.addListener(() {
      print(focusNode.hasFocus);
    });
  }


}

class DescriptionView extends StatefulWidget {
  final List<Widget> children;
  DescriptionView({this.children});
  @override
  _DescriptionViewState createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView> {
  // List<String> _detailTypes = ['ICD', 'CFS'];
  List<String> _detailTypes = ['ICD'];
  PageController _pageController;
  List<double> _heights;
  int _currentPage = 0;
  double get _currentHeight  => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController()..addListener(() {
      final _newPage = _pageController.page.round();
      if (_currentPage != _newPage) {
        setState(() => _currentPage = _newPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 60,
              color: footer1,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _detailTypes.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _currentPage == i ?
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width ,
                            height: 30,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle, textAlign: TextAlign.center,),
                            ),
                          ) :
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width ,
                            height: 30,
                            margin: EdgeInsets.only(left: 8),
                            //color: footer1,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle1,  textAlign: TextAlign.center,),
                            ),
                          )
                      ),
                      onTap: () {
                        setState(() {
                          _currentPage = i;
                          _pageController.animateToPage(i, curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 400));
                        });
                      },
                    );
                  }),
            ),
            TweenAnimationBuilder<double>(
              curve: Curves.easeInOutCubic,
              tween: Tween<double>(begin: _heights[0], end: _currentHeight),
              duration: const Duration(milliseconds: 100),
              builder: (c, v, child) {
                return SizedBox(height: v, child: child);
              },
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: _sizeReportingChildren.asMap().map((index, child) =>
                    MapEntry(index, child)).values.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children.asMap().map((index, child) =>
      MapEntry(index, OverflowBox(
        minHeight: 0, maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: SizeReportingWidget(
          onSizeChanged: (size) => setState(() => _heights[index] = size?.height ?? 0),
          child: Align(child: child,),
        ),
      ))).values.toList();

}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChanged;
  SizeReportingWidget({this.child, this.onSizeChanged});
  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.mounted) {
        _notifySize();
      }
    });
    return widget.child;
  }

  _notifySize() {
    final size = context?.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChanged(size);
    }
  }

}
