import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/pages/movie_details.dart';
import 'package:movie_swiper/presentation/pages/watchlist_page.dart';
import 'presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(title: 'Home');
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            Movie movie = state.extra as Movie;
            return MovieDetailsPage(movie:movie);
          },
        ),
        GoRoute(
          path: 'watchlist',
          builder: (BuildContext context, GoRouterState state) {
            return const WatchlistPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
