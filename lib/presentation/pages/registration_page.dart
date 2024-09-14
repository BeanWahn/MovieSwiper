import 'package:flutter/material.dart';
import 'package:movie_swiper/presentation/components/registration_form.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                Text("Register",
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                const RegistrationForm()
              ],
            )),
      ),
    );
  }
}
