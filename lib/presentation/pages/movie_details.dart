import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/presentation/components/movie_thumbnail_card.dart';
import 'package:movie_swiper/services/genre_service.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/services/movies_service.dart';
import 'package:movie_swiper/services/user_service.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final GenreService genreService = GenreService();
  final MoviesService moviesService = MoviesService();
  final UserService userService = UserService();
  final List genres = GenreService().genres;
  int recommendationPage = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String movieImage = "https://placehold.co/200x400.png?text=No+Image";
    if (widget.movie.backdropPath != null) {
      movieImage =
          "https://image.tmdb.org/t/p/original${widget.movie.backdropPath!}";
    }
    if (widget.movie.posterPath != null) {
      movieImage =
          "https://image.tmdb.org/t/p/original${widget.movie.posterPath!}";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: ListView(children: [
        Image(
          image: NetworkImage(movieImage),
          fit: BoxFit.fitWidth,
        ),
        Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                    height: 1,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.movie.releaseDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                moviesService.buildRatingStars(widget.movie.voteAverage, true),
                const SizedBox(height: 8),
                if (widget.movie.genreIds != null &&
                    widget.movie.genreIds!.isNotEmpty)
                  genreService.buildGenreBadges(widget.movie.genreIds!),
                const SizedBox(height: 16),
                Text(
                  widget.movie.overview,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 36),
                FutureBuilder(
                    future: moviesService.getRecommendedMovies([widget.movie],
                        page: recommendationPage),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 35,
                          );
                        } else {
                          recommendationPage = snapshot.data!['page'];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Recommended Movies",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {
                                        recommendationPage += 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              for (Movie movie
                                  in snapshot.data!['recommendations'])
                                MovieThumbnailCard(movie: movie),
                              const SizedBox(height: 36),
                            ],
                          );
                        }
                      }
                    }),
              ],
            ))
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 75.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child:
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              heroTag: null,
              backgroundColor: Colors.red[600],
              onPressed: () {
                context.go('/', extra: "left");
              },
              child: const Icon(size: 28, Icons.delete_forever, color: Colors.white),
            )),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child:
            FloatingActionButton(
              mini: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              heroTag: null,
              backgroundColor: Colors.blue[400],
              onPressed: () {
                userService.addMovieToWatchlist(
                    widget.movie, FirebaseAuth.instance.currentUser!.uid);
              },
              child: const Icon(Icons.book, color: Colors.white, size: 20,),
            )),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child:
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              heroTag: null,
              backgroundColor: Colors.green[400],
              onPressed: () {
                userService.addMovieToWatchlist(
                    widget.movie, FirebaseAuth.instance.currentUser!.uid);
              },
              child: const Icon(Icons.favorite, color: Colors.white),
            ))
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}
