import 'package:flutter/material.dart';
import 'jackpotGames.dart';
import 'jackpotBoards.dart';

const int TAB_SIZE = 2;
class Jackpot extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: TAB_SIZE,
      child: Scaffold(
        appBar: AppBar(
          title:Text('ሃገሬ ጃክፖት'),
          bottom: TabBar(
            tabs: [
              Tab(text:'Games',icon:Icon(Icons.sports_esports)),
              Tab(text:'Jackpot Cartelas',icon:Icon(Icons.table_chart))
            ],
          ),
        ),
        body: TabBarView(
          children: [
              JackpotGames(),
              JackpotBoards()
          ],
        ),
      ),
    );
  }
}