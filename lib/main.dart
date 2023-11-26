import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    String? result = "Hello World...!";
    Future _scanQR() async {
      try {
        String? cameraScanResult = await scanner.scan();
        //print(cameraScanResult);

        /*setState(() {
          result = cameraScanResult; // setting string result with cameraScanResult
        });*/
      } on PlatformException catch (e) {
        print(e);
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        initialIndex: 1,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title:  Text('ሃገሬ ጌምስ ካርቴላ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            centerTitle: true,
            backgroundColor:Color(0xFF356DE5),
            toolbarHeight: 80.0,
            // This check specifies which nested Scrollable's scroll notification
            // should be listened to.
            //
            // When `ThemeData.useMaterial3` is true and scroll view has
            // scrolled underneath the app bar, this updates the app bar
            // background color and elevation.
            //
            // This sets `notification.depth == 1` to listen to the scroll
            // notification from the nested `ListView.builder`.
            /*notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            // The elevation value of the app bar when scroll view has
            // scrolled underneath the app bar.
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.qr_code),
                  text: 'Scan',
                ),
                Tab(
                  icon: const Icon(Icons.clear_all),
                  text: 'Clear',
                ),
                Tab(
                  icon: const Icon(Icons.exit_to_app),
                  text: 'Exit',
                ),
                Tab(
                  icon: const Icon(Icons.supervised_user_circle),
                  text: 'About Us',
                ),
              ],
            ),*/
          ),
          body:SingleChildScrollView(
            child:  Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: const MyHomePage(),
            ),
          ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0xFF356DE5), // Add this
              selectedItemColor: Colors.white, // Add this

              unselectedItemColor: Colors.white.withOpacity(1), // Add this
              //selectedFontSize: 14.0, // Add this
              //unselectedFontSize: 14.0, // Add this
              type: BottomNavigationBarType.fixed, // Add this
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2),
                  label: 'Scan',
                ),
                BottomNavigationBarItem(


                  icon: Icon(Icons.cleaning_services_rounded),
                  label: 'Clear',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  label: 'About Us',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: 'Exit',
                ),

              ],
              onTap: (index) {
                if (index == 0) {//scan
                  print('Home');
                  _scanQR();
                } else if (index == 1) {//clear
                  print('us');
                } else if (index == 2) {//about us
                  print('Favorites');
                } else if (index == 3) {//exit
                  print('Settings');
                }
              },
            ),
        ),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final comp_id_controller = TextEditingController();
  final board_id_controller = TextEditingController();

  List<List<int>> numbers = List.generate(5, (index) => List.generate(5,(j)=>0));
  List<Color> colors = List.generate(25, (index) => Colors.white);

  @override
  Widget build(BuildContext context) {
    var blueShades = [Colors.blue[200], Colors.blue[300], Colors.blue[400], Colors.blue[500], Colors.blue[600]];
    return Material(
      child: Column(
        children: <Widget>[
          /*TextField(
            controller: comp_id_controller,
            decoration: InputDecoration(hintText: 'Enter Company Id'),
            onSubmitted: (value){
              setState(() {
                numbers = fetchNumbers(value);
              });
            },
          ),*/
          Row( // Add this
            children: <Widget>[
              Expanded( // Add this
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: TextField(
                    controller: board_id_controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
                    decoration: InputDecoration(
                      hintText: 'ካርቴላ ቁጥር እዚ ያስገቡ',
                      //filled: true, // Add this
                      //fillColor: Colors.blue[100], // Add this
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder( // Add this
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue), // Modify this
                      ), // Add this
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        numbers = fetchNumbers(value);
                      });
                    },
                  ),
                ),
              ), // Add this
              /*IconButton( // Add this
                icon: Icon(Icons.search, color: Colors.blue), // Add this
                onPressed: () {
                  setState(() {
                    numbers = fetchNumbers(board_id_controller.text);
                  });
                }, // Add this
              ),*/ // Add this
            ],
          ), // A,
          Row(// Add this
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add this
            children: 'BINGO'.split('').map((letter) => Text(letter, style: TextStyle(fontSize: 52.0, color: blueShades['BINGO'.indexOf(letter)],fontWeight: FontWeight.w900))).toList(), // Add this
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:GridView.builder(
            shrinkWrap: true,
            itemCount: 25,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
            ),
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    colors[index] = colors[index] == Colors.white ? Colors.blue : Colors.white;
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
                        child:Text(
                          numbers[index ~/ 5][index % 5] == 0 ? '' : numbers[index ~/ 5][index % 5].toString(),
                          style:TextStyle(
                              fontSize: 48.0,
                              color: colors[index] == Colors.white ?  Colors.blueGrey: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                          ,)),
                  ),
                ),
              );
            },
          ),)
        ],
      ),

    );
  }
  List<List<int>> fetchNumbers(String company_id){
    var rng = Random();
    return List.generate(5, (index) => List.generate(5,(j)=>rng.nextInt(75) + 1));
  }
  List<List<int>> selectId(List<List<int>> numbers,int id){
    return numbers.map((list)=>list.map((number)=>number == id ? number : 0).toList()).toList();
  }
}
