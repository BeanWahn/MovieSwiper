import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              print(watchlist);
              if(watchlist == null || watchlist.isEmpty) {
                return const Text('No movies in watchlist');
              }else{
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(watchlist[index].title),
                    );
                  },
                );
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
