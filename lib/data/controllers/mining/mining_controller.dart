import 'package:flutter/cupertino.dart';
import 'package:quanthex/data/Models/mining/mining_dto.dart';
import 'package:quanthex/data/services/mining/mining_service.dart';
import 'package:quanthex/utils/logger.dart';

class MiningController extends ChangeNotifier{

  MiningService miningService=MiningService.getInstance();

  List<MiningDto> minings=[];



  Future<void> fetchMinings()async{
    logger("Getting minings", runtimeType.toString());
    List<MiningDto> results=await miningService.getMinings();
    minings=results;
    notifyListeners();
  }


  void setMinings(List<MiningDto> newMinings){
    minings=newMinings;
    notifyListeners();
  }


}