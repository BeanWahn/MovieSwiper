class Movie {
  int movieId;
  bool adult;
  String? backdropPath;
  String? posterPath;
  List<dynamic>? genreIds;
  String? originalLanguage;
  String? originalTitle;
  double popularity;
  String title;
  String overview;
  double voteAverage;
  int voteCount;
  bool video;
  String releaseDate;

  Movie({
    required this.movieId,
    required this.adult,
    this.backdropPath,
    this.posterPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    required this.popularity,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.video,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['id'],
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      genreIds: json['genre_ids'] ??
          (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['id'])
              .toList(),
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      popularity: json['popularity'],
      title: json['title'],
      overview: json['overview'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      video: json['video'],
      releaseDate: json['release_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': movieId,
      'adult': adult,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'genre_ids': genreIds,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'title': title,
      'overview': overview,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'video': video,
      'release_date': releaseDate,
    };
  }
}

class FetchMovieResponse {
  int page;
  List<Movie> results;

  FetchMovieResponse({
    required this.page,
    required this.results,
  });

  factory FetchMovieResponse.fromJson(Map<String, dynamic> json) {
    return FetchMovieResponse(
      page: json['page'],
      results: (json['results'] as List<dynamic>)
          .map((movie) => Movie.fromJson(movie))
          .toList(),
    );
  }
}