import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/presentation/components/login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}