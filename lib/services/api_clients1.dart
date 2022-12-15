import 'package:http/http.dart'as http;
import 'package:navkar_tracker/models/collection_model.dart';
import 'package:navkar_tracker/models/kdm_model.dart';
import 'package:navkar_tracker/models/outstanding_cust_model.dart';
import 'package:navkar_tracker/models/overall_model.dart';
import 'package:navkar_tracker/models/performance_model.dart';
import 'dart:convert';
import 'connection.dart';

import '../models/outstanding_model.dart';
import '../models/billing_model.dart';

class ApiClient1 {

  //outstanding
  Future<OutstandingModel> getIFCOutDetails() async {
    var response = await http.get(Uri.parse(Connection.ifcOut));
    print("IFC outstand $response");
    var result = json.decode(response.body);
    print("IFC result outstand $result");

    OutstandingModel _ifcOut;
    _ifcOut = (OutstandingModel.fromJson(result));
    print("ifc out $_ifcOut");
    return _ifcOut;
  }

  Future<OutstandingModel> getCFSOutDetails() async {
    var response = await http.get(Uri.parse(Connection.cfsOut));
    print("CFS outstand $response");
    var result = json.decode(response.body);
    print("CFS result outstand $result");


    OutstandingModel _cfsOut;
    _cfsOut = (OutstandingModel.fromJson(result));
    print("ifc out $_cfsOut");

    return _cfsOut;
  }

  //billing
  Future<BillingModel> getICDBillDetails() async {
    var response = await http.get(Uri.parse(Connection.ifcBill));
    print("ICD Bill $response");
    var result = json.decode(response.body);
    print("ICD result Bill $result");
    print("ICD Bill Url ${Connection.ifcBill}");


    BillingModel _icdBill;
    _icdBill = (BillingModel.fromJson(result));
    print("ifc bill $_icdBill");

    return _icdBill;
  }

  Future<BillingModel> getCFSBillDetails() async {
    var response = await http.get(Uri.parse(Connection.cfsBill));
    print("CFS Bill $response");
    var result = json.decode(response.body);
    print("CFS result Bill $result");
    print("CFS Bill ${Connection.cfsBill}");


    BillingModel _cfsBill;
    _cfsBill = (BillingModel.fromJson(result));
    print("cfs bill $_cfsBill");

    return _cfsBill;
  }

  //overall
  Future<OverallModel> getIFCOverallDetails() async {
    var response = await http.get(Uri.parse(Connection.ifcOverall));
    print("IFC Overall $response");
    var result = json.decode(response.body);
    print("IFC result Overall $result");

    OverallModel _ifcOverall;
    _ifcOverall = (OverallModel.fromJson(result));
    print("ifc Overall $_ifcOverall");
    return _ifcOverall;
  }

  Future<OverallModel> getCFSOverallDetails() async {
    var response = await http.get(Uri.parse(Connection.cfsOverall));
    print("CFS Overall $response");
    var result = json.decode(response.body);
    print("CFS result Overall $result");


    OverallModel _cfsOverall;
    _cfsOverall = (OverallModel.fromJson(result));
    print("ifc Overall $_cfsOverall");

    return _cfsOverall;
  }

  //cust wise
  Future<OutstandingCustModel> getIFCCustDetails(String from, String to) async {
    var response = await http.get(Uri.parse(Connection.ifcCustAeging+"?fromRange=$from&toRange=$to"));
    print("IFC Overall $response");
    var result = json.decode(response.body);
    print("IFC result Overall $result");

    OutstandingCustModel _ifcOverall;
    _ifcOverall = (OutstandingCustModel.fromJson(result));
    print("ifc Overall $_ifcOverall");
    return _ifcOverall;
  }

  Future<OutstandingCustModel> getCFSCustDetails(String from, String to) async {
    var response = await http.get(Uri.parse(Connection.cfsCustAeging+"?fromRange=$from&toRange=$to"));
    print("CFS Overall $response");
    var result = json.decode(response.body);
    print("CFS result Overall $result");


    OutstandingCustModel _cfsOverall;
    _cfsOverall = (OutstandingCustModel.fromJson(result));
    print("ifc Overall $_cfsOverall");

    return _cfsOverall;
  }

  //KDM
  Future<KdModel> getIFCKDM() async {
    var response = await http.get(Uri.parse(Connection.kdmIcd));
    print("IFC Overall $response");
    var result = json.decode(response.body);
    print("IFC result Overall $result");

    KdModel _ifcKDM;
    _ifcKDM = (KdModel.fromJson(result));
    print("ifc KDM $_ifcKDM");
    return _ifcKDM;
  }

  Future<KdModel> getCFSKDM() async {
    var response = await http.get(Uri.parse(Connection.kdmCfs));
    print("CFS Overall $response");
    var result = json.decode(response.body);
    print("CFS result Overall $result");


    KdModel _cfsKDM;
    _cfsKDM = (KdModel.fromJson(result));
    print("ifc KDM $_cfsKDM");

    return _cfsKDM;
  }


  //Collection
  Future<CollectionModel> getIFCCollection(String date) async {
    var response = await http.get(Uri.parse("${Connection.collectionIcd}?date=$date"));
    print("IFC Collection $response");
    var result = json.decode(response.body);
    print("IFC result collection $result");

    CollectionModel _ifcCollection;
    _ifcCollection = (CollectionModel.fromJson(result));
    print("ifc collection $_ifcCollection");
    return _ifcCollection;
  }

  Future<CollectionModel> getCFSCollection(String date) async {
    var response = await http.get(Uri.parse("${Connection.collectionCfs}?date=$date"));
    print("CFS collection $response");
    print("CFS collection $response");
    var result = json.decode(response.body);
    print("CFS collection Url ${Connection.collectionCfs}?date=$date");


    CollectionModel _cfsKDM;
    _cfsKDM = (CollectionModel.fromJson(result));
    print("ifc collection $_cfsKDM");

    return _cfsKDM;
  }

  //Performance
  Future<PerformanceModel> getIFCPerformance() async {
    var response = await http.get(Uri.parse("${Connection.performnaceIcd}?MonthRange=6"));
    print("IFC Performance $response");
    var result = json.decode(response.body);
    print("IFC result Performance $result");

    PerformanceModel _ifcPerformance;
    _ifcPerformance = (PerformanceModel.fromJson(result));
    print("ifc Performance $_ifcPerformance");
    return _ifcPerformance;
  }

  Future<PerformanceModel> getCFSPerformance() async {
    var response = await http.get(Uri.parse(Connection.performanceCfs+"?MonthRange=6"));
    print("CFS Performance $response");
    var result = json.decode(response.body);
    print("CFS result Performance $result");
    print("CFS result Performance ${Connection.performanceCfs+"?MonthRange=6"}");


    PerformanceModel _cfsPerformance;
    _cfsPerformance = (PerformanceModel.fromJson(result));
    print("ifc Performance $_cfsPerformance");

    return _cfsPerformance;
  }

}