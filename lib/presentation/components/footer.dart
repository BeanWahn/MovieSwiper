import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            context.go('/');
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Add your logic here
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            context.go('/watchlist');
          },
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Add your logic here
          },
        ),
      ],
    ));
  }
}
