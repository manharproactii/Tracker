import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:navkar_tracker/bloc/performance_bloc.dart';
import 'package:navkar_tracker/models/performance_model.dart';
import 'package:navkar_tracker/utils/alerts.dart';
import 'package:navkar_tracker/utils/app_properties.dart';

import '../dashboards/dashboard_admin.dart';

class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {

  final icdBloc = PerformanceBloc();
  final cfsBloc = PerformanceBloc();

  AsyncSnapshot<PerformanceModel> asi, asc;
  List<SaleMonthWise> sales = [];

  @override
  initState(){
    super.initState();
    icdBloc.fetchICDPerformance();
    cfsBloc.fetchCFSPerformance();
  }

  @override
  void dispose() {
    super.dispose();
    icdBloc.dispose();
    cfsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
        return;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar:_appBar(),
        body: _body(),
      ),
    );
  }
  Widget _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (c) => DashboardAdmin()));
        },),
      backgroundColor: bg,
      centerTitle: true,
      elevation: 0,
      title: Text("Sales Person Performance",
        style: content,),
      actions: [
        IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: (){
              Alerts.showLogOut(context, "LogOut", "Are you sure?");
            }),
      ],
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: StreamBuilder<PerformanceModel>(
          stream: icdBloc.icdStream,
          builder: (c, si) {
            asi = si;
            return StreamBuilder<PerformanceModel>(
                stream: cfsBloc.cfsStream,
                builder: (c, sc) {
                  asc = sc;

                  if (asi.connectionState != ConnectionState.active || asc.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(height : 300, alignment: Alignment.center, child: Center(heightFactor: 50, child: CircularProgressIndicator(),));
                  }
                  if (asc.hasError && asi.hasError) {
                    print("as3 error");
                    return Container(height: 300, alignment: Alignment.center, child: Text("Error Loading Data", style: content,),);
                  }
                  if (asc.data.toString().isEmpty && asi.data.toString().isEmpty) {
                    print("as3 empty");
                    return Container(height: 300, alignment: Alignment.center, child: Text("No Data Found", style: content,),);
                  }

                  sales = List.from(asc.data.performances[0].saleMonthWises.reversed);

                  print("object ${sales[0].month} ${sales[0].tues}");

                  return Container(
                    alignment: Alignment.topCenter,
                    child: DescriptionView(
                        children : [
                          asi.data.performances.isNotEmpty ? Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: HorizontalDataTable(
                                    leftHandSideColumnWidth: 100,
                                    rightHandSideColumnWidth: 800,
                                    isFixedHeader: true,
                                    headerWidgets:[
                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(color: Colors.white),),
                                          child: Container(
                                            child: Text('Sales Person',
                                              style: content1,
                                              textAlign: TextAlign.center,),
                                            alignment: Alignment.center,)),
                                      // Expanded(
                                      //   child: Container(
                                      //     height: 50,
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.green,
                                      //       border: Border.all(color: Colors.white),
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         for(int i=0; i<asi.data.performances[0].saleMonthWises.length; i++)
                                      //         Expanded(
                                      //           child: Container(
                                      //             child: Text('${asi.data.performances[0].saleMonthWises[i].month}',
                                      //               style: content1,
                                      //               textAlign: TextAlign.center,),
                                      //             alignment: Alignment.center,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        height: 50,
                                        // decoration: BoxDecoration(
                                        //   color: Colors.green,
                                        //   border: Border.all(color: Colors.white),
                                        // ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for(int i=0; i<asi.data.performances[0].saleMonthWises.length; i++)
                                              Container(
                                                width: 133,
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    border: Border(
                                                      right: BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                      top:  BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                      bottom: BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  // border: Border.all(color: Colors.white),
                                                ),
                                                child: Text('${asi.data.performances[0].saleMonthWises[i].month}',
                                                  style: content1,
                                                  textAlign: TextAlign.center,),
                                                alignment: Alignment.center,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    leftSideItemBuilder: _generateFirstColumnRow,
                                    rightSideItemBuilder: _generateRightHandSideColumnRow,
                                    itemCount: asi.data.performances.length,
                                    rightHandSideColBackgroundColor: Colors.black,
                                    leftHandSideColBackgroundColor: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],),
                          ): Container(),
                          asc.data.performances.isNotEmpty ? Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: [
                                Container(

                                  height: MediaQuery.of(context).size.height,
                                  width: 800,
                                  child: HorizontalDataTable(
                                    leftHandSideColumnWidth: 100,
                                    rightHandSideColumnWidth: 800,
                                    isFixedHeader: true,
                                    headerWidgets:[
                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(color: Colors.white),),
                                          child: Container(
                                            child: Text('Sales Person',
                                              style: content1,
                                              textAlign: TextAlign.center,),
                                            alignment: Alignment.center,)),
                                      // Expanded(
                                      //   child: Container(
                                      //     height: 50,
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.green,
                                      //       border: Border.all(color: Colors.white),
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         for(int i=0; i<asc.data.monthHeaders.length; i++)
                                      //           Expanded(
                                      //             child: Container(
                                      //               child: Text('${asc.data.monthHeaders[i].month}',
                                      //                 style: content1,
                                      //                 textAlign: TextAlign.center,),
                                      //               alignment: Alignment.center,
                                      //             ),
                                      //           ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(
                                        height: 50,
                                        // decoration: BoxDecoration(
                                        //   color: Colors.green,
                                        //   border: Border.all(color: Colors.white),
                                        // ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for(int i=0; i<asc.data.monthHeaders.length; i++)
                                              Container(
                                                width: 133,
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    border: Border(
                                                      right: BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                      top:  BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                      bottom: BorderSide( //                   <--- right side
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  // border: Border.all(color: Colors.white),
                                                ),
                                                child: Text('${asc.data.monthHeaders[i].month}',
                                                  style: content1,
                                                  textAlign: TextAlign.center,),
                                                alignment: Alignment.center,
                                              ),
                                          ],
                                        ),
                                      ),],
                                    leftSideItemBuilder: _generateFirstColumnRow1,
                                    rightSideItemBuilder: _generateRightHandSideColumnRow1,
                                    itemCount: asc.data.performances.length,
                                    rightHandSideColBackgroundColor: Colors.black,
                                    leftHandSideColBackgroundColor: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],),
                          ): Container(),
                        ]
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: Colors.white),right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
      ),
      child: Text("${asi.data.performances[index].salsePerson}", style: content1,
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
          for(int x =0; x<asi.data.performances[index].saleMonthWises.length; x++)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
              ),
              child: Text("${asi.data.performances[index].saleMonthWises[x].tues}", style: content1,
                textAlign: TextAlign.center,),
              //width: 150,
              //height: 52,
              //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
      child: Text("${asc.data.performances[index].salsePerson}", style: content1,
        textAlign: TextAlign.center,),
      //width: 100,
      //height: 52,
      //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow1(BuildContext context, int index) {

    for(int i=0; i<asc.data.monthHeaders.length; i++)
      for(int j=0; j<asc.data.performances[index].saleMonthWises.length; j++)
      // print("object ${asc.data.monthHeaders[i].month} ==  ${asc.data.performances[0].saleMonthWises[j].month}");

    return Container(
      color: Colors.black,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          for(int x =0; x<asc.data.monthHeaders.length; x++)
            for(int j=0; j<asc.data.performances[index].saleMonthWises.length; j++)
              asc.data.monthHeaders[x].month == asc.data.performances[0].saleMonthWises[0].month ? Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.white),bottom: BorderSide(color: Colors.white)),
                  ),
                  child:Text("${asc.data.performances[index].saleMonthWises[j].tues}", style: content1,
                    textAlign: TextAlign.center,),
                  //width: 150,
                  //height: 52,
                  //padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.center,
                ),
              ) : Container(),
        ],
      ),
    );
  }
}

class DescriptionView extends StatefulWidget {
  final List<Widget> children;
  DescriptionView({this.children});
  @override
  _DescriptionViewState createState() => _DescriptionViewState();
}

class _DescriptionViewState extends State<DescriptionView> {
  List<String> _detailTypes = ['ICD', 'CFS'];
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
                            width: MediaQuery.of(context).size.width / 2,
                            height: 30,
                            child: Center(
                              child: Text('${_detailTypes[i]}', style: optionStyle, textAlign: TextAlign.center,),
                            ),
                          ) :
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2,
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
