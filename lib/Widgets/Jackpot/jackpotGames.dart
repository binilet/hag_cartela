import 'package:flutter/material.dart';
import 'package:hag_cart/States/games_state.dart';
import 'package:hag_cart/Widgets/Jackpot/gameCard.dart';
import 'package:provider/provider.dart';


class JackpotGames extends StatefulWidget{
  const JackpotGames({Key? key}) : super(key:key);

  @override
  State<JackpotGames> createState() => _JackpotGamesState();
}

class _JackpotGamesState extends State<JackpotGames>{
  @override
  void initState(){
    super.initState();
    Future.microtask(()=>
      context.read<GamesProvider>().getOrRefreshGames()
    );
  }

  @override
  Widget build(BuildContext context){
    return Consumer<GamesProvider>(
      builder: (context,provider,child){
        return RefreshIndicator(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: _buildContent(provider),
                ),

              ],
            ),
            onRefresh: provider.getOrRefreshGames);
      },
    );
  }
  Widget _buildContent(GamesProvider provider) {
    if (provider.isLoading && provider.games.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.error != null && provider.games.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                provider.error!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: provider.getOrRefreshGames,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.games.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'No games available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => GameCard(game: provider.games[index]),
        childCount: provider.games.length,
      ),
    );
  }
}
