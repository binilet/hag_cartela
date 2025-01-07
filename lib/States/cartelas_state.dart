import 'package:flutter/foundation.dart';
import 'package:hag_cart/Widgets/Jackpot/jackpotBoardApiCall.dart';
import '../Widgets/Jackpot/jackpotBoardStorage.dart';
import '../Widgets/Jackpot/boardModel.dart';


class CartelasProvider extends ChangeNotifier
{

  String _boardSelectionMessage = '';
  final List<Board> _selectedBoards = [];
  List<Board> _availableBoards = [];
  final JackpotBoardStorage _storage = JackpotBoardStorage();

  CartelasProvider()
  {
    _loadSavedBoards();
  }

  List<Board> get selectedBoards => _selectedBoards;
  List<Board> get availableBoards => _availableBoards;
  String get boardSelectionMessage => _boardSelectionMessage;


  Future<void> _loadSavedBoards() async {
    final boards = await _storage.loadBoards();
    _availableBoards = boards;
    notifyListeners();
  }


  Future<void> loadBoardsFromServer() async{
    final boards = await fetchMockBoards();
    await _storage.saveBoards(boards);
    _availableBoards = boards;
    notifyListeners();
  }

  void addBoard(int boardId){
    final  board = _availableBoards.where((board) => board.boardId == boardId);
    if(board.isNotEmpty && !_selectedBoards.contains(board.first)){
      _selectedBoards.add(board.first);
      _boardSelectionMessage='';
      notifyListeners();
    }else{
      _boardSelectionMessage = 'board unavailable or already selected!';
    }
  }
  void removeBoard(int boardId){
    _selectedBoards.remove(boardId);
    notifyListeners();
  }
  final Map<int, Set<String>> selectedCells = {}; // Map boardId to selected cells

  void toggleCell(int boardId, int row, int col) {
    final cellKey = '$row-$col';
    selectedCells.putIfAbsent(boardId, () => <String>{});

    if (selectedCells[boardId]!.contains(cellKey)) {
      selectedCells[boardId]!.remove(cellKey);
    } else {
      selectedCells[boardId]!.add(cellKey);
    }

    notifyListeners();
  }

  // Check if a cell is selected
  bool isCellSelected(int boardId, int row, int col) {
    return selectedCells[boardId]?.contains('$row-$col') ?? false;
  }
}
