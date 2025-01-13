class GameModel{
  final String gameName;
  final double betAmount;
  final double totalWinning;
  final String totalJackpot;
  final DateTime dateTime;
  final String time;
  final bool isDone;

  GameModel({
    required this.gameName,
    required this.betAmount,
    required this.totalWinning,
    required this.totalJackpot,
    required this.dateTime,
    required this.time,
    required this.isDone
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      gameName: json['game_name'] ?? '',
      betAmount: (json['bet_amount'] ?? 0).toDouble(),
      totalWinning: (json['total_winning'] ?? 0).toDouble(),
      totalJackpot: json['total_jackpot'] ?? 0,
      dateTime: DateTime.tryParse(json['date_time'] ?? '') ?? DateTime.now(),
      time: json['time'] ?? '',
      isDone: json['is_done'] ?? false,
    );
  }

}