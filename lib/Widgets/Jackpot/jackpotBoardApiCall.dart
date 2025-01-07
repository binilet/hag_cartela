import 'package:hag_cart/Widgets/Jackpot/boardModel.dart';

Future<List<Board>> fetchMockBoards() async{
  await Future.delayed(Duration(seconds: 2));

  return List.generate(10,
      (index) => Board(
        boardId: index+1,
        boardName: 'Board ${index+1}',
        boardNumbers: List.generate(5, (_) => List.generate(5,(_)=>index+1)),
        companyId: 'c0001',
        branchId:'b0001',
        isActive: true,
        isReserved: false
      ));
}