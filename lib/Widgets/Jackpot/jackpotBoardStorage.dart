import 'package:hag_cart/Widgets/Jackpot/boardModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JackpotBoardStorage{

  Future<void> saveBoards(List<Board> boards) async
  {
    final prefs = await SharedPreferences.getInstance();
    final encodedBoards = boards.map((board) => json.encode(board.toJson())).toList();
    prefs.setStringList('savedBoards', encodedBoards);
  }

  ///load from saved local preference storage
  Future<List<Board>> loadBoards() async
  {
    final prefs = await SharedPreferences.getInstance();
    final savedBoards = prefs.getStringList('savedBoards')??[];
    return savedBoards.map((board) => Board.fromJson(json.decode(board))).toList();
  }

  Future<void> clearBoards() async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('savedBoards');
  }

}