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
  }

  @override
  Widget build(BuildContext context) {
    List<Color> blueShades = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue];
    final myState = Provider.of<ScannerState>(context);
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
                  child: Column(
                    children: [
                      TextField(
                        controller: board_id_controller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        decoration: InputDecoration(
                          hintText: 'ካርቴላ ቁጥር እዚ ያስገቡ',
                          icon: Icon(
                            Icons.table_chart_sharp,//clear selected cells
                            color: Colors.blue, // adjust as needed
                            size: 12.0,
                          ),
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

                      Column(
                        children: [
                          Text(
                            myState.isLoadingDone ? '${myState.message}' : '',
                            style: TextStyle(
                                color: myState.boards.length > 0 ? Colors.blue : Colors.red,
                                fontWeight: FontWeight.w400),

                          ),
                          Text(
                            myState.scannedCompanyId != null ? myState.scannedCompanyId.toString() : '',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400),

                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ), // Add this
            ],
          ), // A,

          Consumer<ScannerState>(builder: (context, ScannerState, _) {
            return ScannerState.isLoading ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue,),
                    SizedBox(height: 16,),
                    Text(
                      'Loading Cartelas...', // Display a loading message
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )
                  ],
                ),
            )  : Wrap(
              spacing: 2.0, // space between rows
              runSpacing: 10.0, // space between lines
              children: List<Widget>.generate(
                  ScannerState.selected_boards.length, (boardIndex) {
                //List<Color> boardColors = List.filled(25, Colors.white);

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
                                  boardColorsList?[boardIndex][index] =
                                  boardColorsList?[boardIndex][index] == Colors.white ? Colors.blue : Colors.white;
                                });
                              },
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: boardColorsList?[boardIndex][index],
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Center(
                                    child: (index % 5 == 2 && index ~/ 5 == 2)
                                        ? Icon(
                                      Icons.ac_unit_rounded, // replace with your preferred icon
                                      color: boardColorsList?[boardIndex][index] == Colors.white
                                          ? Colors.blueGrey
                                          : Colors.white,
                                    )
                                        : Text(
                                      ScannerState.selected_boards[boardIndex]
                                          .cartNums[index % 5][index ~/ 5]
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 24.0, // adjust as needed
                                        color: boardColorsList?[boardIndex][index] == Colors.white
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
                            'Board: ${ScannerState.selected_boards[boardIndex].boardId}',
                            // Add your board number here
                            style: TextStyle(
                              fontSize: 14.0,
                              // adjust as needed
                              fontWeight: FontWeight.bold,
                              // adjust as needed
                              color: Colors.blue, // adjust as needed
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cleaning_services_sharp,//clear selected cells
                              color: Colors.red, // adjust as needed
                              size: 16.0,
                            ),
                            onPressed: () {
                              // Add your clear function here
                              for(int i = 0;i<25;i++){
                                setState(() {
                                  boardColorsList?[boardIndex][i] =Colors.white;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red, // adjust as needed
                              size: 16.0, // adjust as needed
                            ),
                            onPressed: () {
                              // Add your clear function here
                              ScannerState.removeBoard(ScannerState.selected_boards[boardIndex].boardId);
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
