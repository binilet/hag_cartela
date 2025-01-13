import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'gameModel.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  const GameCard({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              game.isDone ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.attach_money_rounded,
                'Bet Amount',
                currencyFormat.format(game.betAmount),
                Colors.grey[800]!,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.stars_rounded,
                'Total Winning',
                currencyFormat.format(game.totalWinning),
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.workspace_premium_rounded,
                'Jackpot Prize',
                game.totalJackpot.toString(),
                Colors.orange,
              ),
              const SizedBox(height: 20),
              _buildTimeStamp(dateFormat.format(game.dateTime)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: game.isDone ? Colors.green : Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.casino_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            game.gameName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: game.isDone ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            game.isDone ? 'Completed' : 'Scheduled',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeStamp(String timestamp) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          timestamp,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
