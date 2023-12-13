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
      {
        required this.boardId,
      required this.branch,
      required this.companyId,
      required this.cartNums
      });
}

class ScannerState extends ChangeNotifier {

  String? _scannedCompanyId = "";
  String? get scannedCompanyId => _scannedCompanyId;

  List<Board> _boards = [];

  List<Board> _selected_boards = [];
  List<Board> get selected_boards => _selected_boards;

  Board? _selectedBoard;
  bool _isLoading = false;

  bool _isLoadingDone = false;
  bool get isLoadingDone => _isLoadingDone;

  bool get isLoading => _isLoading;

  List<Board> get boards => _boards;

  Board? get selectedBoard => _selectedBoard;

  String? _message;
  String? get message => _message;



  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void removeBoard(int id){
    _selected_boards.removeWhere((element) => element.boardId == id);
    notifyListeners();
  }

  void resetBoards(){
    if(selected_boards != null){
      _selected_boards = [];
    }
    notifyListeners();
  }

  void setSelectedBoard(String value) {
    //print('from new screeen.[$value]');
    //print('from new screeen.${_boards.length}');
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
        _message = "Cartela not found!";
        notifyListeners();
    }
    if (selected != null) {
      if(_selected_boards!.length < 4 )
      {
        if (!_selected_boards!.contains(selected)) {
          _selectedBoard = selected;
          _selected_boards?.add(_selectedBoard!);
          _message = "";
        } else {
          _selected_boards.removeWhere((element) => element.boardId.toString() == value);
          //_message = "Board already added!";
        }
      }else{
        _message = "Maximum board reached (4)!";
      }

    } else {
      _message = "No board found with board Id: $value";
    }
    notifyListeners();
  }


  Future scanQR() async {
    try {
      String? cameraScanResult = await scanner.scan();
      _scannedCompanyId = cameraScanResult;
      _isLoadingDone = false;

      //production url
      var url = Uri.parse("http://161.35.114.115:5001/api/boards/company/$_scannedCompanyId");


      //test url
      //var url = Uri.parse("https://a3cdba200cac419a9db92572fbcb9a07.api.mockbin.io/");


      var response = await http.get(url,headers: {'x-api-key': 'b7a3c12d7b9e46a396155c95b052f94e'});
      //var response = await http.get(url);
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
        for (int i = 0; i < _boards.length; i++) print(_boards[i].boardId);

      } else {
        _isLoadingDone = true;
        setIsLoading(false);
        _message = "Failed to load boards";
        //throw Exception("Failed to load boards");
        print('failed to load boards');
      }
      _message = "${_boards.length} Cartelas found!";
      _isLoadingDone = true;
      notifyListeners();
    } on PlatformException catch (e) {
      print('exception thrown');
      _isLoadingDone = true;
      setIsLoading(false);
    }
  }
}
