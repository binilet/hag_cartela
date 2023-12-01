import 'package:flutter/cupertino.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Board {
  final int boardId;
  final String branch;
  final String companyId;
  final List<List<int>> cartNums;

  Board(
      {required this.boardId,
      required this.branch,
      required this.companyId,
      required this.cartNums});
}

class ScannerState extends ChangeNotifier {

  String? scannedCompanyId = "";
  List<Board> _boards = [];

  List<Board> _selected_boards = [];
  List<Board> get selected_boards => _selected_boards;

  Board? _selectedBoard;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Board> get boards => _boards;

  Board? get selectedBoard => _selectedBoard;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void resetBoards(){
    if(selected_boards != null){
      _selected_boards = [];
    }
    notifyListeners();
  }

  void setSelectedBoard(String value) {
    if (_boards == null || _boards.isEmpty) {
      print('No boards available.');
      // You might want to throw an exception or handle this case differently based on your requirements.
      return;
    }

    Board? selected;
    try{
      selected = _boards.firstWhere(
              (element) => element.boardId.toString() == value
      );
    }catch(e){
        print('no fikir objects');
    }
    // Assuming boardId is an integer


    if (selected != null) {
      _selectedBoard = selected;
      _selected_boards?.add(_selectedBoard!);
    } else {
      print('No board found with boardId: $value');
      // You might want to throw an exception or handle this case differently based on your requirements.
    }

    notifyListeners();
  }


  Future scanQR() async {
    try {
      //String? cameraScanResult = await scanner.scan();
      //scannedCompanyId = cameraScanResult;

      //var url = Uri.parse("http://192.168.56.1:5000/api/boards/company/$scannedCompanyId");
      var url =
          Uri.parse("https://a3cdba200cac419a9db92572fbcb9a07.api.mockbin.io/");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        _boards = data
            .map((item) => Board(
                boardId: item['board_id'],
                branch: item['branch_id'],
                companyId: item['company_id'],
                cartNums: List<List<int>>.from(
                    item['board_numbers'].map((i) => List<int>.from(i)))))
            .toList();
        print(
            '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
        print(_boards.length);
        print(_boards[0]?.cartNums);
        print(
            '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
        for (int i = 0; i < _boards.length; i++) print(_boards[i].boardId);
      } else {
        throw Exception("Failed to load boards");
      }

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
