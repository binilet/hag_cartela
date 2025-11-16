import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hag_cart/States/cartelas_state.dart';
import 'package:hag_cart/States/games_state.dart';
import './Widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';
import './States/scanner_state.dart';
import './Widgets/BoardSelector.dart';
import './Widgets/Jackpot/ApiService.dart';

void main() {
  //const String baseUrl = 'http://localhost:5000/api';
  //const String baseUrl = 'http://192.168.142.93:5000/api';
  //https://api.hagere-games.com/api
  const String baseUrl = 'https://api.hagere-games.com/api';
  final apiService = ApiService(baseUrl: baseUrl);
  runApp(MyApp(apiService: apiService));
}
class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({super.key,required this.apiService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScannerState()),
        ChangeNotifierProvider(create: (context)=> CartelasProvider(apiService: this.apiService)),
        ChangeNotifierProvider(create: (context) => GamesProvider(apiService: this.apiService))
      ],
      child: MaterialApp(
        title: 'Hagere Games',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            elevation: 5.0,
            title: const Text(
              'Hagere Games Cartela',
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,// const Color(0xFF356DE5),
            toolbarHeight: 60.0,
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: MyHomePage(),
            ),
          ),
          bottomNavigationBar: BottomNavigator(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final comp_id_controller = TextEditingController();
  final board_id_controller = TextEditingController();

  List<List<int>>? numbers;

  //List.generate(5, (index) => List.generate(5, (j) => 0));
  List<Color> colors = List.generate(25, (index) => Colors.white);

  // Initialize a separate colors list for each board
  List<List<Color>>? boardColorsList;

  @override
  void initState() {
    super.initState();
    // Initialize the colors list for each board
    Future.delayed(Duration.zero, () {
      final scannerState = Provider.of<ScannerState>(context, listen: false);

      // Now you can use scannerState here
      // For example:
       boardColorsList = List.generate(
         scannerState.selected_boards.length == 0 ? 4 : scannerState.selected_boards.length,
        (_) => List.filled(25, Colors.white),
       );
    });

    _loadBoards();
  }

  // Load boards from SharedPreferences and notify listeners
  void _loadBoards() async {
    await Provider.of<ScannerState>(context, listen: false).loadBoards();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> blueShades = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue
    ];
    final myState = Provider.of<ScannerState>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.04;

    return Material(
      child: Column(
        children: <Widget>[
          // Select Cartela Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardSelectorWidget(data: myState.boards),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        'Select Cartela Here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      myState.isLoadingDone ? '${myState.message}' : '',
                      style: TextStyle(
                        color: myState.boards.length > 0 ? Colors.blue : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      myState.scannedCompanyId != null
                          ? myState.scannedCompanyId.toString()
                          : '',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Selected Boards Display
          Consumer<ScannerState>(
            builder: (context, scannerState, _) {
              if (scannerState.isLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        'Loading Cartelas...',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              final selectedBoards = scannerState.selected_boards;
              final isSingleBoard = selectedBoards.length == 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isSingleBoard ? 1 : 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 8,
                  childAspectRatio: isSingleBoard ? 0.85 : 0.75,
                ),
                itemCount: selectedBoards.length,
                itemBuilder: (context, boardIndex) {
                  final board = selectedBoards[boardIndex];
                  final boardWidth = isSingleBoard
                      ? screenWidth - 10
                      : screenWidth / 2 - 7;

                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSingleBoard ? 16 : 12),
                      child: Column(
                        children: [
                          // BINGO Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: 'BINGO'.split('').asMap().entries.map((entry) {
                              return Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: isSingleBoard ? 28.0 : 20.0,
                                  color: blueShades[entry.key],
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

                          SizedBox(height: isSingleBoard ? 12 : 8),

                          // Bingo Grid
                          AspectRatio(
                            aspectRatio: 1,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 25,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: isSingleBoard ? 4 : 3,
                                mainAxisSpacing: isSingleBoard ? 4 : 3,
                              ),
                              itemBuilder: (context, index) {
                                final isFreeSpace = index % 5 == 2 && index ~/ 5 == 2;
                                final cellColor = boardColorsList?[boardIndex][index] ?? Colors.white;
                                final isMarked = cellColor != Colors.white;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      boardColorsList?[boardIndex][index] =
                                      isMarked ? Colors.white : Colors.blue;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cellColor,
                                      borderRadius: BorderRadius.circular(
                                        isSingleBoard ? 8 : 6,
                                      ),
                                      border: Border.all(
                                        color: isMarked
                                            ? Colors.blue[700]!
                                            : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isFreeSpace
                                          ? Icon(
                                        Icons.star,
                                        color: isMarked
                                            ? Colors.white
                                            : Colors.amber,
                                        size: isSingleBoard ? 24 : 18,
                                      )
                                          : Text(
                                        board.cartNums[index % 5][index ~/ 5]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: isSingleBoard ? 18 : 13,
                                          color: isMarked
                                              ? Colors.white
                                              : Colors.blueGrey[800],
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: isSingleBoard ? 12 : 8),

                          // Board ID and Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  'Board: ${board.boardId}',
                                  style: TextStyle(
                                    fontSize: isSingleBoard ? 16.0 : 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < 25; i++) {
                                      boardColorsList?[boardIndex][i] = Colors.white;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.orange,
                                    size: isSingleBoard ? 18.0 : 16.0,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  scannerState.removeBoard(board.boardId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: isSingleBoard ? 18.0 : 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  List<List<int>> fetchNumbers(String company_id) {
    var rng = Random();
    return List.generate(
        5, (index) => List.generate(5, (j) => rng.nextInt(75) + 1));
  }

  List<List<int>> selectId(List<List<int>> numbers, int id) {
    return numbers
        .map((list) => list.map((number) => number == id ? number : 0).toList())
        .toList();
  }
}
