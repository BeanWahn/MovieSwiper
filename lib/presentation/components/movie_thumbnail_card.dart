import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/services/genre_service.dart';
import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/services/movies_service.dart';

class MovieThumbnailCard extends StatefulWidget {
  final Movie movie;

  const MovieThumbnailCard({
    super.key,
    required this.movie,
  });

  @override
  State<MovieThumbnailCard> createState() => _MovieThumbnailCardState();
}

class _MovieThumbnailCardState extends State<MovieThumbnailCard> {
  final MoviesService moviesService = MoviesService();
  final GenreService genreService = GenreService();
  final List genres = GenreService().genres;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Add border radius of 10
        image: DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/original${widget.movie.backdropPath ?? widget.movie.posterPath}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15), // Add padding on all sides
        // New Container for the gradient overlay
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Add border radius of 10
          backgroundBlendMode: BlendMode.darken,
          color: Colors.black.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.releaseDate,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            moviesService.buildRatingStars(widget.movie.voteAverage, false),
            const SizedBox(height: 8),
            if (widget.movie.genreIds != null &&
                widget.movie.genreIds!.isNotEmpty)
              genreService.buildGenreBadges(widget.movie.genreIds!),
            const SizedBox(height: 8),
            Text(
              widget.movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      GoRouter.of(context).push('/details', extra: widget.movie);
    },
    );
  }
}
