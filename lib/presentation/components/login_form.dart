import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/services/user_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userService = UserService();

  AuthException? loginError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loginError?.message != null && loginError?.errorType == 'general')
            Text(loginError!.message, style: const TextStyle(color: Colors.red)),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email address.';
              }
              if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address.';
              }
              if (loginError?.errorType == 'email') {
                return loginError?.message;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (loginError?.errorType == 'password') {
                return loginError?.message;
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                  print("Signed In");
                  context.go("/home");
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    loginError = userService.getAuthException(e.code);
                  });
                }
              }
            },
            child: const Text('Login'),
          ),
          const Row(children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(14.0),
              child: Text("OR"),
            ),
            Expanded(child: Divider()),
          ]),
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              context.go('/register');
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
