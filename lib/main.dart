import 'package:movie_swiper/models/movie.dart';
import 'package:movie_swiper/presentation/pages/login_page.dart';
import 'package:movie_swiper/presentation/pages/movie_details.dart';
import 'package:movie_swiper/presentation/pages/registration_page.dart';
import 'package:movie_swiper/presentation/pages/search_page.dart';
import 'package:movie_swiper/presentation/pages/settings_page.dart';
import 'package:movie_swiper/presentation/pages/watchlist_page.dart';
import 'presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAuth.instance.useAuthEmulator('https://127.0.0.1', 9099);
  
  FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
    user = user;
  });

  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        if(user == null) {
          return const LoginPage();
        } else {
          return HomePage(user:user);
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationPage();
          },
        ),
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
            return WatchlistPage(user:user);
          },
        ),
        GoRoute(
          path: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return SearchPage();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsPage();
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
