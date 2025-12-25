// To parse this JSON data, do
//
//     final rpcModel = rpcModelFromJson(jsonString);

import 'dart:convert';

RpcModel rpcModelFromJson(String str) => RpcModel.fromJson(json.decode(str));

String rpcModelToJson(RpcModel data) => json.encode(data.toJson());

class RpcModel {
  int? id;
  String? jsonrpc;
  String? method;
  List<dynamic>? params;

  RpcModel({
    this.id,
    this.jsonrpc,
    this.method,
    this.params,
  });

  factory RpcModel.fromJson(Map<String, dynamic> json) => RpcModel(
    id: json["id"],
    jsonrpc: json["jsonrpc"],
    method: json["method"],
    params: json["params"] == null ? [] : List<dynamic>.from(json["params"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "jsonrpc": jsonrpc,
    "method": method,
    "params": params == null ? [] : List<dynamic>.from(params!.map((x) => x)),
  };
}

class ParamClass {
  String? from;
  String? to;
  String? value;
  String? data;

  ParamClass({
    this.from,
    this.to,
    this.value,
    this.data,
  });

  factory ParamClass.fromJson(Map<String, dynamic> json) => ParamClass(
    from: json["from"],
    to: json["to"],
    value: json["value"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "value": value,
    "data": data,
  };
}
