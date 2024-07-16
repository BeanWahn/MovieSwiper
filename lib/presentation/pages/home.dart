import 'dart:convert';

import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/presentation/components/movie_card.dart';
import 'package:movie_swiper/services/movies_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;

  MoviesService moviesService = MoviesService();
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<MovieCard>> getMovies(int page) async {
    Response response = await moviesService.fetchMovies(page);
    List<MovieCard> newCards = [];
    for (var movie in json.decode(response.body)['results']) {
      try {
        Movie newMovie = Movie.fromJson(movie);
        newMovie.releaseDate = newMovie.releaseDate.replaceAll("-", "/");
        newCards.add(MovieCard(
          movie: newMovie,
        ));
        movies.add(newMovie);
      } catch (e) {
        print(e);
      }
    }
    return newCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.filter_alt_rounded),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: SafeArea(
              child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          )),
        ),
        body: FutureBuilder(
          future: getMovies(page),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("No movies found"),
                );
              }
              List<MovieCard> cards = snapshot.data!;
              return SafeArea(
                  child: Column(children: [
                Expanded(
                  child: CardSwiper(
                    onEnd: () => {
                      setState(() {
                        page += 1;
                      }),
                    },
                    isLoop: false,
                    cardsCount: cards.length,
                    cardBuilder: (context, index, percentThresholdX,
                            percentThresholdY) =>
                        cards[index],
                  ),
                ),
                Footer(),
              ]));
            }
          },
        ));
  }
}
