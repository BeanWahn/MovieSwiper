import 'package:flutter/material.dart';
import 'package:movie_swiper/presentation/components/footer.dart';
import 'package:movie_swiper/presentation/components/movie_thumbnail_card.dart';
import 'package:movie_swiper/services/genre_service.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/services/movies_service.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final GenreService genreService = GenreService();
  final MoviesService moviesService = MoviesService();
  final List genres = GenreService().genres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: ListView(children: [
        // Container(
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         image: NetworkImage(
        //           'https://image.tmdb.org/t/p/original${widget.movie.posterPath ?? widget.movie.backdropPath}',
        //         ),
        //         fit: BoxFit.fitWidth,
        //       ),
        //     )),
        Image(image: NetworkImage(
          'https://image.tmdb.org/t/p/original${widget.movie.posterPath ?? widget.movie.backdropPath}',
        ),
        fit: BoxFit.fitWidth,),
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
                const SizedBox(height: 24),
                const Text(
                  "Recommended Movies",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder(
                    future: moviesService.getRecommendedMovies([widget.movie]),
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
                      }
                      return Column(
                        children: [
                          for (Movie movie in snapshot.data!)
                            if (movie.genreIds != null &&
                                movie.genreIds!.isNotEmpty &&
                                widget.movie.genreIds != null &&
                                widget.movie.genreIds!.isNotEmpty &&
                                movie.genreIds!
                                        .toSet()
                                        .intersection(
                                            widget.movie.genreIds!.toSet())
                                        .length >
                                    1)
                                    MovieThumbnailCard(movie: movie),
                                    const SizedBox(height: 12),
                        ],
                      );
                    }),
              ],
            ))
      ]),
      bottomSheet: SafeArea(
        maintainBottomViewPadding: true,
        minimum: const EdgeInsets.only(bottom: 15),
        child:Footer(),
      ),
    );
  }
}
