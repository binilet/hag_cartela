import 'package:flutter/foundation.dart';
import 'package:hag_cart/Widgets/Jackpot/ApiService.dart';
import '../Widgets/Jackpot/jackpotBoardStorage.dart';
import '../Widgets/Jackpot/boardModel.dart';
import '../Widgets/Jackpot/ApiService.dart';


class CartelasProvider extends ChangeNotifier
{

  final ApiService _apiService;

  String _boardSelectionMessage = '';
  final List<Board> _selectedBoards = [];
  List<Board> _availableBoards = [];
  final JackpotBoardStorage _storage = JackpotBoardStorage();

  CartelasProvider({required ApiService apiService})
  : _apiService = apiService
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
    final boards = await _apiService.fetchMockBoards();
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
  void removeBoard(int boardId) {
    print('Board to remove: $boardId');
    print('Selected boards before removal: ${_selectedBoards.length}');

    // Find the board in _selectedBoards by boardId
    Board? boardToRemove;
    if (_selectedBoards.any((board) => board.boardId == boardId)) {
      boardToRemove = _selectedBoards.firstWhere(
            (board) => board.boardId == boardId,
      );
    } else {
      // Handle the case where the board is not found (e.g., log an error)
      print('Board with ID $boardId not found.');
    }

    if (boardToRemove != null) {
      _selectedBoards.remove(boardToRemove);
      print('Selected boards after removal: ${_selectedBoards.length}');
      notifyListeners();
    } else {
      print('Board not found in selected boards!');
    }
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
