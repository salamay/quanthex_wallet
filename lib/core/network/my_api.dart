import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class MyApi{

  static const coinMarketCapKey="4adc2f15-9dfb-40f1-ae39-94c36a81891b";
  static const coinGecko="CG-tcE5kazL3EhqnL2pKhfJmSqD";
  static const bscScanKey="44F2IJ8EJQT5JAWUIFWRH96SKIGSNWXJZB";
  static const ethScanKey="H1DPN1Y5C1BCHBQW3MEWABBZ16ANIAUC1T";
  static const polScanKey="ZYTD2GBM6NQCPI3FXVJYBQPS9H57K28WB2";
  static const moralisKey="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImYxMmNkMGJjLWU4M2UtNGFlMy05ZTRhLTI3YzY5ZDViYmI4MiIsIm9yZ0lkIjoiNDU5ODI4IiwidXNlcklkIjoiNDczMDc5IiwidHlwZUlkIjoiYmMyZGMyMjgtMTAzMi00NmZlLTg3YjMtMWE5MTM4ZTllNjdmIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3NTI3NTMzNjksImV4cCI6NDkwODUxMzM2OX0.xegyqypNhaFqqiiN378Ii2ECOWgc-ZP5rENdobDV9A4";
  Dio dio = Dio();


  Future<Response?> post(var body,String urlLocation,var headers)async{
    try{
      log("POST Request to $urlLocation with body: $body");
      final response = await dio.post(
        urlLocation,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json, // ensures JSON decoding
          // contentType: Headers.jsonContentType, // sets 'application/json; charset=utf-8'
          validateStatus: (status) {
            return validate(status);
          },
        ),
      );
      return response;
    }catch(e){
      log(e.toString());
      throw Exception(e);
    }
  }
  Future<Response?> get(String urlLocation,var headers)async{
    try{
      log("GET Request to $urlLocation");
      Response? response = await dio.get(
        urlLocation,
        options: Options(
          headers: headers,
          responseType: ResponseType.json, // ensures correct decoding
          validateStatus: (status) {
            return validate(status);
          },
        ),
      );
      return response;
    }catch(e){
      log(e.toString());

    }
  }

  Future<Stream<http.StreamedResponse>> streamPost(String location,dynamic body,var headers)async{
    var url = Uri.parse(location);
    http.BaseRequest request = http.Request('POST',url);
    try{
      request.headers.addAll(headers);
      final Stream<http.StreamedResponse> response =http.Client().send(request).asStream();
      return response;
    }catch(e){
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<http.StreamedResponse> streamGet(String location,var headers)async{
    var url = Uri.parse(location);
    http.BaseRequest request = http.Request('GET',url);
    try{
      request.headers.addAll(headers);
      final http.StreamedResponse response =await http.Client().send(request);
      return response;
    }catch(e){
      log(e.toString());
      throw Exception(e);
    }
  }
  Future<Response> singleMultipartRequest(String urlLocation,Uint8List fromBytes,String fileName,var headers,Function(int sent,int total) onProgressUpdate)async{
    // Create a FormData object to hold the file and any other data
    FormData formData = FormData.fromMap({
      "file":  MultipartFile.fromBytes(fromBytes, filename: fileName)
    });
    // Make the request
    Response response = await dio.post(
      urlLocation,
      data: formData,
      options: Options(
          headers: headers
      ),
      onSendProgress: (int sent, int total){
        onProgressUpdate(sent, total);
      }
    );
    return response;
  }

  bool validate(int? status){
    if(status==null){
      return false;
    }
    if(status<=500){
      return true;
    }else{
      return false;
    }
  }
}