import 'package:flutter/material.dart';
import 'package:movie_swiper/presentation/components/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Login",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 16),
                  const LoginForm(),
                ])),
      ),
    );
  }
}
