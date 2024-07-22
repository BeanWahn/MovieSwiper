import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/services/user_service.dart';

class WatchlistPage extends StatefulWidget {
  final User? user;
  const WatchlistPage({super.key, this.user});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final Future<List<Movie>> _watchlist =
        userService.getWatchlist(widget.user?.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        FutureBuilder<List<Movie>>(
          future: _watchlist,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final watchlist = snapshot.data;
              if(watchlist == null || watchlist.isEmpty) {
                return const Text('No movies in watchlist');
              }else{
                return Expanded(child:GridView.count(
                  crossAxisCount: 2,
                  children: watchlist.map((movie) {
                    String movieImage = "https://placehold.co/200x400.png?text=No+Image";
                    if (movie.backdropPath != null) {
                      movieImage =
                          "https://image.tmdb.org/t/p/original${movie.backdropPath!}";
                    }
                    if (movie.posterPath != null) {
                      movieImage =
                          "https://image.tmdb.org/t/p/original${movie.posterPath!}";
                    }
                    return InkWell(onTap:() => context.push('/details',extra: movie),child:Card(
                      child: Column(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500$movieImage',
                            fit: BoxFit.cover,
                            height: 100,
                            width:100
                          ),
                          Text(movie.title),
                        ],
                      ),
                    ));
                  }).toList(),
                ));
              }
            }
          },
        ),
        Footer(),
      ]),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WatchlistPage(),
  ));
}
