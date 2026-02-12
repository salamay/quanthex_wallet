import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyApi{

  static const coinGecko="CG-8PWXisCcwmHNbHFN4Mxby1zY";
  static const ethScanKey="N8N1CQHKPX5YY1Q219XNX2EJRWDRUIGY2W";
  static const moralisKey="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjJjZDlkYTRlLWVkZmUtNDJmNC1iOGRmLTIwMTk4OTE2YmJlNiIsIm9yZ0lkIjoiNDk4OTgzIiwidXNlcklkIjoiNTEzNDY1IiwidHlwZUlkIjoiYjdkNmZkNjUtODk2OC00NjI0LTk2YmItMTkwMDEwZmIxNjFhIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3NzA0MjY4NDcsImV4cCI6NDkyNjE4Njg0N30.h46nVUkFn9XpCi0FpRWHLsTlaC-_xSd5Ie3BizSaBCo";
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