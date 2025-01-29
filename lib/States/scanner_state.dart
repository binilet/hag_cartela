import 'package:flutter/cupertino.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Widgets/QRScannerScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Board {
  final int boardId;
  final String branch;
  final String companyId;
  final List<List<int>> cartNums;

  Board({
      required this.boardId,
      required this.branch,
      required this.companyId,
      required this.cartNums});

  Map<String, dynamic> toJson() {
    return {
      'board_id': boardId,
      'board_numbers': cartNums,
      'company_id': companyId,
      'branch_id': branch,
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      boardId: json['board_id'],
      cartNums: List<List<int>>.from(
          json['board_numbers'].map((row) => List<int>.from(row))),
      companyId: json['company_id'],
      branch: json['branch_id'],
    );
  }


}

class ScannerState extends ChangeNotifier {

  String? _scannedCompanyId = "";
  String? get scannedCompanyId => _scannedCompanyId;

  List<Board> _boards = [];
  List<Board> get boards => _boards;


  List<Board> _selected_boards = [];
  List<Board> get selected_boards => _selected_boards;

  Board? _selectedBoard;
  bool _isLoading = false;

  bool _isLoadingDone = false;
  bool get isLoadingDone => _isLoadingDone;

  bool get isLoading => _isLoading;



  Board? get selectedBoard => _selectedBoard;

  String? _message;
  String? get message => _message;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void removeBoard(int id) {
    _selected_boards.removeWhere((element) => element.boardId == id);
    notifyListeners();
  }

  void resetBoards() {
    if (selected_boards != null) {
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
    try {
      selected =
          _boards.firstWhere((element) => element.boardId.toString() == value);
    } catch (e) {
      _message = "Cartela not found!";
      notifyListeners();
    }
    if (selected != null) {
      if (_selected_boards!.length < 4) {
        if (!_selected_boards!.contains(selected)) {
          _selectedBoard = selected;
          _selected_boards?.add(_selectedBoard!);
          _message = "";
        } else {
          _selected_boards
              .removeWhere((element) => element.boardId.toString() == value);
          //_message = "Board already added!";
        }
      } else {
        _message = "Maximum board reached (4)!";
      }
    } else {
      _message = "No board found with board Id: $value";
    }
    notifyListeners();
  }

  /*Future scanQR() async {
    try {
      final MobileScannerController controller = MobileScannerController();
      String? cameraScanResult;//await scanner.scan();
      await controller.start();
      controller.barcodes.listen((barcodeCapture){
        if(barcodeCapture.barcodes.isNotEmpty){
          cameraScanResult = barcodeCapture.barcodes.first.rawValue;
          if(cameraScanResult != null)
            controller.stop();
        };
      });

    // Wait until a barcode is scanned
    while (cameraScanResult == null) {
    await Future.delayed(const Duration(milliseconds: 100));
    }



      _scannedCompanyId = cameraScanResult;
      _isLoadingDone = false;

      //production url
      var url = Uri.parse(
          "http://161.35.114.115:5001/api/boards/company/$_scannedCompanyId");

      //test url
      //var url = Uri.parse("https://a3cdba200cac419a9db92572fbcb9a07.api.mockbin.io/");

      var response = await http
          .get(url, headers: {'x-api-key': 'b7a3c12d7b9e46a396155c95b052f94e'});
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
  }*/

  Future<void> scanQR(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScannerScreen(
          onScanned: (String scannedData) async {
            _scannedCompanyId = scannedData;
            await fetchBoardData();
          },
        ),
      ),
    );
  }

  Future<void> fetchBoardData() async {
    try {
      _isLoadingDone = false;

      // Production URL
      var url = Uri.parse(
          "http://161.35.114.115:5001/api/boards/company/$_scannedCompanyId");

      // Send GET request
      var response = await http.get(
        url,
        headers: {'x-api-key': 'b7a3c12d7b9e46a396155c95b052f94e'},
      );

      if (response.statusCode == 200) {
        // Parse response data
        var data = jsonDecode(response.body) as List;
        _boards = data
            .map((item) => Board(
          boardId: item['board_id'],
          branch: item['branch_id'],
          companyId: item['company_id'],
          cartNums: List<List<int>>.from(
              item['board_numbers'].map((i) => List<int>.from(i))),
        ))
            .toList();

        //save to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('normalBoards');
        final encodedBoards = _boards.map((board) => json.encode(board.toJson())).toList();
        prefs.setStringList('normalBoards', encodedBoards);

        print('Boards loaded successfully');
      } else {
        print('Failed to load boards');
      }

      _message = "${_boards.length} Cartelas found!";

    } catch (e) {
      print('Error fetching board data: $e');
    } finally {
      _isLoadingDone = true;
      notifyListeners();
    }
  }

  ///load from saved local preference storage
  Future<void> loadBoards() async
  {
    _isLoadingDone = false;
    _message = "Loading...";
    notifyListeners();  // Notify UI that loading has started

    final prefs = await SharedPreferences.getInstance();
    final savedBoards = prefs.getStringList('normalBoards')??[];
    List<Board> storedBoards =  savedBoards.map((board) => Board.fromJson(json.decode(board))).toList();
    _boards = storedBoards;
    _isLoadingDone = true;
    _message = "${_boards.length} Saved Cartelas found!";

    notifyListeners();
  }
}
