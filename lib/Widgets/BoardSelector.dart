import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../States/scanner_state.dart';


class BoardSelectorWidget extends StatelessWidget {
  final List<Board> data;

  const BoardSelectorWidget({super.key, required this.data});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          // const Color(0xFF356DE5),
          toolbarHeight: 60.0,
          actions: [
            IconButton(
              icon: Icon(Icons.done, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: BoardSelectorWidgetState(data:data),
            ),
          ),

        ),
      );

  }
}

class BoardSelectorWidgetState extends StatefulWidget {
  final List<Board> data;
  const BoardSelectorWidgetState({super.key, required this.data});

  @override
  State<BoardSelectorWidgetState> createState() => BoardSelector(data);
}


class BoardSelector extends State<BoardSelectorWidgetState>{
  final List<Board> data;
  BoardSelector(this.data);

  List<bool>? selectedBoards;

  @override
  void initState() {
    super.initState();
    selectedBoards = List.generate(data.length, (index) => false);
  }

  List<Color> blueShades = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context)
  {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the text size based on the screen width
    double textSize = screenWidth * 0.04; // You can adjust the multiplier as needed

        return Wrap(
          spacing: 2.0, // space between rows
          runSpacing: 10.0, // space between lines
          children: List<Widget>.generate(data.length, (boardIndex) {
            return SizedBox(
              width: data.length < 2
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
                    child: GestureDetector(
                      onTap: () {
                          setState(() {
                            selectedBoards?[boardIndex] =
                                !selectedBoards![boardIndex];
                          });
                        Provider.of<ScannerState>(context, listen: false)
                            .setSelectedBoard(data[boardIndex].boardId.toString());
                      },
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
                              selectedBoards?[boardIndex] =
                              !selectedBoards![boardIndex];
                              Provider.of<ScannerState>(context, listen: false)
                                  .setSelectedBoard(data[boardIndex].boardId.toString());
                            });
                          },
                          child: Card(
                            elevation: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedBoards![boardIndex]
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Center(
                                child: (index % 5 == 2 && index ~/ 5 == 2)
                                    ? Icon(
                                  Icons.ac_unit_rounded,
                                  color:
                                  Colors.black
                                  ,
                                )
                                    : Text(
                                  data[boardIndex]
                                      .cartNums[index % 5][index ~/ 5]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: textSize, // adjust as needed
                                    color: selectedBoards![boardIndex]
                                        ? Colors.white
                                        : Colors.blueGrey
                                    ,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // adjust as needed
                    children: <Widget>[
                      Text(
                        'Board: ${data[boardIndex].boardId}',
                        // Add your board number here
                        style: TextStyle(
                          fontSize: 14.0,
                          // adjust as needed
                          fontWeight: FontWeight.bold,
                          // adjust as needed
                          color: Colors.blue, // adjust as needed
                        ),
                      ),


                    ],
                  )
                ],
              ),
            );
          }),
        );
  }
}