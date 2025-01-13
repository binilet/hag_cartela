import 'dart:io';

import 'package:hag_cart/Widgets/Jackpot/boardModel.dart';
import 'package:hag_cart/Widgets/Jackpot/gameModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  final String baseUrl;
  ApiService({required this.baseUrl});
  
  Future<List<GameModel>> fetchGames() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/jackpot/gamesFormobile'),
      headers:{
        'Content-Type' : 'application/json',
        //add auth header here
          },
      ).timeout(const Duration(seconds: 10));
      
      if(response.statusCode == 200){

        final dynamic result = json.decode(response.body);
        print(result);
        final List<dynamic> gamesJson= result['data'];
        print(gamesJson);
        return gamesJson.map((json) => GameModel.fromJson(json)).toList();
      }else{
        throw HttpException('Failed to load games: ${response.statusCode}');
      }
    }catch(e){
      throw Exception('Failed to fetch games: $e');
    }
  }

  Future<List<Board>> fetchMockBoards() async{
    try{
      String _scannedCompanyId = "HagereGames_HG";
      final response = await http.get(Uri.parse("$baseUrl/boards/company/$_scannedCompanyId"),
        headers:{
          'Content-Type' : 'application/json',
          'x-api-key': 'b7a3c12d7b9e46a396155c95b052f94e'
        },
      ).timeout(const Duration(seconds: 10));

      if(response.statusCode == 200){

        final List<dynamic> result = json.decode(response.body);
        return result.map((json) => Board.fromJson(json)).toList();
      }else{
        throw HttpException('Failed to load games: ${response.statusCode}');
      }
    }catch(e){
      throw Exception('Failed to fetch boards: $e');
    }
  }

  Future<List<Board>> fetchMockBoardss() async{
    await Future.delayed(Duration(seconds: 2));

    return List.generate(10,
            (index) => Board(
            boardId: index+1,
            boardName: 'Board ${index+1}',
            boardNumbers: List.generate(5, (_) => List.generate(5,(_)=>index+1)),
            companyId: 'c0001',
            branchId:'b0001',
            isActive: true,
            isReserved: false
        ));
  }
}

