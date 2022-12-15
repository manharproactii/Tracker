import 'package:navkar_tracker/models/mark_location.dart';

import '../models/detail_model.dart';
import '../models/dmr_model.dart';

import 'package:http/http.dart'as http;
import 'dart:convert';
import 'connection.dart';

class ApiClient {

  Future<MarkLocationModel> getYardDataSummary() async {
    print("getYardDataSummary URL ========> ${Connection.getYardDataSummary}");
    var response = await http.get(Uri.parse(Connection.getYardDataSummary));
    var result = json.decode(response.body);

    MarkLocationModel _markLocation;

    print("_markLocation result $result");
    _markLocation = (MarkLocationModel.fromJson(result));
    print('_markLocation details ${_markLocation}');
    return _markLocation;
  }

  Future<DetailModel> getCFSDetails() async {
    var response = await http.post(Uri.parse(Connection.detailCfs));
    var result = json.decode(response.body);

    DetailModel _detailcfs;

    print("cfs result $result");
      _detailcfs = (DetailModel.fromJson(result));
    print('cfs details ${_detailcfs}');
    return _detailcfs;
  }

  Future<DetailModel> getICDDetails() async {
    var response = await http.post(Uri.parse(Connection.detailIcd));
    var result = json.decode(response.body);

    DetailModel _detailicd;

    print("icd result $result");
    _detailicd = (DetailModel.fromJson(result));
    print('icd details $_detailicd');
    return _detailicd;
  }

  Future<DmrModel> getDMRDetails() async {
    var response = await http.get(Uri.parse(Connection.dmr));
    print("url ${Connection.dmr}");
    var result = json.decode(response.body);

    DmrModel _detailDmr;


    _detailDmr = (DmrModel.fromJson(result));
    //print('dmr details $_detailDmr');
    return _detailDmr;
  }

  Future<DmrModel> getDMRCfs() async {
    var response = await http.get(Uri.parse(Connection.dmrCfs));
    var result = json.decode(response.body);

    DmrModel _detailDmr;


    _detailDmr = (DmrModel.fromJson(result));
    //print('dmrcfs details $_detailDmr');
    return _detailDmr;
  }

  Future<DmrModel> getDMRYard1() async {
    var response = await http.get(Uri.parse(Connection.dmrYard1));
    var result = json.decode(response.body);

    DmrModel _detailDmr;


    _detailDmr = (DmrModel.fromJson(result));
    //print('yard1 details $_detailDmr');
    return _detailDmr;
  }

  Future<DmrModel> getDMRYard2() async {
    var response = await http.get(Uri.parse(Connection.dmrYard2));
    var result = json.decode(response.body);

    DmrModel _detailDmr;


    _detailDmr = (DmrModel.fromJson(result));
    //print('yard2 details $_detailDmr');
    return _detailDmr;
  }

  Future<DmrModel> getDMRYard3() async {
    var response = await http.get(Uri.parse(Connection.dmrYard3));
    var result = json.decode(response.body);
    DmrModel _detailDmr;


    _detailDmr = (DmrModel.fromJson(result));
    print('yard3 details $_detailDmr');
    return _detailDmr;
  }
}