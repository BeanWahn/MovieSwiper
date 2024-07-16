import 'package:flutter/material.dart';

class GenreService {
  Widget buildGenreBadges(List<dynamic> genreIds) {
    return Wrap(
      spacing: 8,
      children: genreIds.map((genreId) {
        final genre = genres.firstWhere((g) => g['id'] == genreId, orElse: () => null);
        if (genre != null) {
          return Chip(
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(100))
              ),
            surfaceTintColor: Colors.black.withOpacity(0.5),
            elevation: 0,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            shadowColor: Colors.black,
            visualDensity: VisualDensity.compact,
            label: Text(
              genre['name'],
              style: const TextStyle(
                height:0,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blueGrey.shade800,
          );
        } else {
          return Container();
        }
      }).toList(),
    );
  }

  List<dynamic> genres = [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 16, "name": "Animation"},
    {"id": 35, "name": "Comedy"},
    {"id": 80, "name": "Crime"},
    {"id": 99, "name": "Documentary"},
    {"id": 18, "name": "Drama"},
    {"id": 10751, "name": "Family"},
    {"id": 14, "name": "Fantasy"},
    {"id": 36, "name": "History"},
    {"id": 27, "name": "Horror"},
    {"id": 10402, "name": "Music"},
    {"id": 9648, "name": "Mystery"},
    {"id": 10749, "name": "Romance"},
    {"id": 878, "name": "Science Fiction"},
    {"id": 10770, "name": "TV Movie"},
    {"id": 53, "name": "Thriller"},
    {"id": 10752, "name": "War"},
    {"id": 37, "name": "Western"}
  ];
}
