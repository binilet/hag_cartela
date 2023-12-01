import 'dart:math';

import 'package:flutter/material.dart';
import './Widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';
import './States/scanner_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScannerState(),
      child: MaterialApp(
        title: 'Hagere Games Cartela Selector',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'ሃገሬ ጌምስ ካርቴላ',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF356DE5),
            toolbarHeight: 80.0,
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

  @override
  Widget build(BuildContext context) {
    /*var blueShades = [
      Colors.blue[200],
      Colors.blue[300],
      Colors.blue[400],
      Colors.blue[500],
      Colors.blue[600]
    ];*/
    List<Color> blueShades = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue];
    return Material(
      child: Column(
        children: <Widget>[
          Row(
            // Add this
            children: <Widget>[
              Expanded(
                // Add this
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0,bottom: 15.0),
                  child: TextField(
                    controller: board_id_controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: 'ካርቴላ ቁጥር እዚ ያስገቡ',
                      //filled: true, // Add this
                      //fillColor: Colors.blue[100], // Add this
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Add this
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide(color: Colors.blue), // Modify this
                      ), // Add this
                    ),
                    onSubmitted: (value) {
                      Provider.of<ScannerState>(context, listen: false)
                          .setSelectedBoard(value);
                      /*setState(() {
                        numbers = fetchNumbers(value);
                      });*/
                    },
                  ),
                ),
              ), // Add this
            ],
          ), // A,
          /*Row(
            // Add this
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add this
            children: 'BINGO'
                .split('')
                .map((letter) => Text(letter,
                    style: TextStyle(
                        fontSize: 52.0,
                        color: blueShades['BINGO'.indexOf(letter)],
                        fontWeight: FontWeight.w900)))
                .toList(), // Add this
          ),*/

          Consumer<ScannerState>(builder: (context, ScannerState, _) {
            return Wrap(
              spacing: 2.0, // space between rows
              runSpacing: 10.0, // space between lines
              children: List<Widget>.generate(
                  ScannerState.selected_boards.length, (boardIndex) {
                List<Color> boardColors = List.filled(25, Colors.white);
                return SizedBox(
                  width: ScannerState.selected_boards.length < 2
                      ? MediaQuery.of(context).size.width - 5
                      : MediaQuery.of(context).size.width / 2 -
                          5, // adjust width as needed
                  child: Column(
                    children: [
                      Row(
                        // Add this
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add this
                        children: 'BINGO'
                            .split('')
                            .map((letter) => Text(letter,
                            style: TextStyle(
                                fontSize: 24.0,
                                color: blueShades['BINGO'.indexOf(letter)],
                                fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow( // bottomLeft
                                  offset: Offset(-1.0, -1.0),
                                  color: Colors.black,
                                )
                              ],
                              letterSpacing: 2.0, // adjust as needed
                              wordSpacing: 2.0, // adjust as needed
                            )),
                        )
                            .toList(), // Add this
                      ),
                      Card(
                        margin: EdgeInsets.all(2.0),
                        // Add margin to create space between the grids
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 25,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  colors[index] = colors[index] == Colors.white
                                      ? Colors.blue
                                      : Colors.white;
                                });
                              },
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ScannerState.selected_boards[boardIndex]
                                          .cartNums[index % 5][index ~/ 5]
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 24.0, // adjust as needed
                                        color: colors[index] == Colors.white
                                            ? Colors.blueGrey
                                            : Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // adjust as needed
                        children: <Widget>[
                          Text(
                            'Board Number: ${ScannerState.selected_boards[boardIndex].boardId}',
                            // Add your board number here
                            style: TextStyle(
                              fontSize: 16.0,
                              // adjust as needed
                              fontWeight: FontWeight.bold,
                              // adjust as needed
                              color: Colors.blue, // adjust as needed
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red, // adjust as needed
                              size: 24.0, // adjust as needed
                            ),
                            onPressed: () {
                              // Add your clear function here
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
            );
          }),
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
