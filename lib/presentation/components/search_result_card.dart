import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/models/movie.dart';

class SearchResultCard extends StatefulWidget {
  final Movie movie;

  const SearchResultCard({Key? key, required this.movie}) : super(key: key);

  @override
  _SearchResultCardState createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  
  @override
  Widget build(BuildContext context) {
    String movieImage = "https://placehold.co/200x400.png?text=No+Image";
    if(widget.movie.backdropPath != null) {
      movieImage = "https://image.tmdb.org/t/p/original${widget.movie.backdropPath!}";
    }
    if(widget.movie.posterPath != null) {
      movieImage = "https://image.tmdb.org/t/p/original${widget.movie.posterPath!}";
    }
    return InkWell(
      child:Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: 
            NetworkImage(movieImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Text(
        widget.movie.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    onTap: () {
      GoRouter.of(context).push('/details', extra: widget.movie);
    },);
  }
}