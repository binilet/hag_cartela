import 'package:flutter/material.dart';
import 'package:hag_cart/Widgets/Jackpot/ApiService.dart';
import 'package:hag_cart/Widgets/Jackpot/gameModel.dart';
import 'dart:convert';

class GamesProvider extends ChangeNotifier{
  final ApiService _apiService;

  List<GameModel> _games = [];
  bool _isLoading = false;
  String? _error;

  GamesProvider({required ApiService apiService}): _apiService = apiService;

  List<GameModel> get games => _games;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getOrRefreshGames() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try{
      final games = await _apiService.fetchGames();
      print(games);
      _games = games;
      //final games = await getSampleGames();

      //final List<dynamic> gamesJson = games;
      //_games = gamesJson.map((json) => GameModel.fromJson(json)).toList();

      _error = null;
    }catch(e){
      _error = 'Failed to load games. Please try again.';
      print(e);
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> getSampleGames() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock JSON response
    final mockData = [
      {
        "game_name": "Soccer Mania",
        "bet_amount": 100.0,
        "total_winning": 500.0,
        "total_jackpot": 2000.0 ,
        "date_time": "2025-01-10T15:30:00",
        "time": "3:30 PM",
        "is_done": false,
      },
      {
        "game_name": "Basketball Kings",
        "bet_amount": 150.0,
        "total_winning": 700.0,
        "total_jackpot": 3500.0,
        "date_time": "2025-01-09T18:00:00",
        "time": "6:00 PM",
        "is_done": true,
      },
      {
        "game_name": "Tennis Legends",
        "bet_amount": 200.0,
        "total_winning": 1000.0,
        "total_jackpot": 4000.0,
        "date_time": "2025-01-08T14:00:00",
        "time": "2:00 PM",
        "is_done": false,
      },
    ];

    return mockData;

  }

}