
import 'package:provider/provider.dart';
import '../States/scanner_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BoardSelectorWidget extends StatelessWidget {
  final List<Board> data;
  const BoardSelectorWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hagere Games Cartela Selector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: const Text(
            'Hagere Games Cartela',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 60.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.done, color: Colors.blue, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: BoardSelectorWidgetState(data: data),
      ),
    );
  }
}

class BoardSelectorWidgetState extends StatefulWidget {
  final List<Board> data;
  const BoardSelectorWidgetState({super.key, required this.data});

  @override
  State<BoardSelectorWidgetState> createState() => _BoardSelectorState();
}

class _BoardSelectorState extends State<BoardSelectorWidgetState> {
  late Map<int, bool> selectedBoards;
  late Map<int, Board> boardMap;

  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  Timer? _debounce;

  final List<Color> bingoColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue
  ];

  @override
  void initState() {
    super.initState();
    // Use Map for O(1) lookups instead of List
    selectedBoards = {for (var board in widget.data) board.boardId: false};
    boardMap = {for (var board in widget.data) board.boardId: board};
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<Board> get filteredData {
    if (searchText.isEmpty) return widget.data;
    return widget.data
        .where((b) => b.boardId.toString().contains(searchText))
        .toList();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchText = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: searchController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "Search by Board ID (numbers only)",
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              suffixIcon: searchText.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() => searchText = "");
                },
              )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        // Results count
        if (searchText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredData.length} board(s) found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Board grid
        Expanded(
          child: filteredData.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No boards found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final board = filteredData[index];
              return BoardCard(
                board: board,
                isSelected: selectedBoards[board.boardId] ?? false,
                bingoColors: bingoColors,
                onTap: () {
                  setState(() {
                    selectedBoards[board.boardId] =
                    !(selectedBoards[board.boardId] ?? false);
                  });
                  Provider.of<ScannerState>(context, listen: false)
                      .setSelectedBoard(board.boardId.toString());
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BoardCard extends StatelessWidget {
  final Board board;
  final bool isSelected;
  final List<Color> bingoColors;
  final VoidCallback onTap;

  const BoardCard({
    super.key,
    required this.board,
    required this.isSelected,
    required this.bingoColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 2.5,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // BINGO header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: 'BINGO'.split('').asMap().entries.map((entry) {
                    return Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 20,
                        color: bingoColors[entry.key],
                        fontWeight: FontWeight.w900,
                        shadows: const [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8),

                // Bingo grid
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 25,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                    ),
                    itemBuilder: (context, index) {
                      final isFreeSpace = index % 5 == 2 && index ~/ 5 == 2;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isFreeSpace
                              ? Icon(
                            Icons.star,
                            color: isSelected ? Colors.white : Colors.amber,
                            size: 18,
                          )
                              : Text(
                            board.cartNums[index % 5][index ~/ 5].toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.white : Colors.blueGrey[800],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Board ID with selection indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 16,
                      ),
                    if (isSelected) const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Board: ${board.boardId}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.blue[700] : Colors.blue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

