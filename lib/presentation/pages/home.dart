import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_swiper/main.dart';
import 'package:movie_swiper/models/filter_list.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/presentation/components/movie_card.dart';
import 'package:movie_swiper/services/genre_service.dart';
import 'package:movie_swiper/services/movies_service.dart';
import 'package:movie_swiper/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.user});
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random rnd = Random();
  int min = 1;
  int max = 500;
  int page = 1;
  bool resetPageIfEmpty = false;

  MoviesService moviesService = MoviesService();
  GenreService genreService = GenreService();
  UserService userService = UserService();
  List<dynamic> genres = [];
  List<Movie> movies = [];

  FilterList filters = FilterList(
    genres: [],
  );

  @override
  void initState() {
    page = min + rnd.nextInt(max - min);
    genres = genreService.genres;
    super.initState();
  }

  Future<List<MovieCard>> getMovies() async {
    List<MovieCard> newCards = [];
    movies = [];
    try{

    FetchMovieResponse response = await moviesService.fetchMovies(page, filters, user?.uid, resetPageIfEmpty: resetPageIfEmpty);
    resetPageIfEmpty = false;
    page = response.page;
    for (var movie in response.results) {
      try {
        movie.releaseDate = movie.releaseDate.replaceAll("-", "/");
        newCards.add(MovieCard(
          movie: movie,
        ));
        movies.add(movie);
      } catch (e) {
        print(e);
      }
    }
    }
    catch(e){
      print(e);
    }
    return newCards;
    
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if(direction.name=="right"){
      userService.addMovieToWatchlist(movies[previousIndex].movieId.toString(), user?.uid);
    }
    else if(direction.name=="left"){
      userService.addMovieToDislikelist(movies[previousIndex].movieId.toString(), user?.uid);
    }
    debugPrint(movies[previousIndex].title);
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.filter_alt_rounded),
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
              Column(
                children: genres
                    .map((genre) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          minVerticalPadding: 0,
                          selected: filters.genres!.contains(genre['id']),
                          selectedColor: Colors.blue,
                          title: Text("${genre['name']}",
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                          onTap: () {
                            setState(() {
                              page = min + rnd.nextInt(max - min);
                              if (filters.genres!.contains(genre['id'])) {
                                filters.genres!.remove(genre['id']);
                              } else {
                                filters.genres!.add(genre['id']);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          )),
        ),
        body: Column(children: [
          Expanded(
            child: FutureBuilder(
            future: getMovies(),
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
                if (cards.isNotEmpty) {
                  return SafeArea(
                    child: CardSwiper(
                      onSwipe: _onSwipe,
                      onEnd: () => {
                        setState(() {
                          resetPageIfEmpty = true;
                          page += 1;
                        }),
                      },
                      isLoop: false,
                      cardsCount: cards.length,
                      cardBuilder: (context, index, percentThresholdX,
                              percentThresholdY) =>
                          cards[index],
                    ),
                  );
                } else {
                  return const SafeArea(
                    child: Center(
                      child: Text("No movies found"),
                    ),
                  );
                }
              }
            },
          )),
          Footer()
        ]));
  }
}
