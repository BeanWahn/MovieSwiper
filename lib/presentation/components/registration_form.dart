import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_swiper/services/user_service.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserService userServ = UserService();

  AuthException? registrationError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (registrationError?.message != null && registrationError?.errorType == 'general')
            Text(registrationError!.message, style: const TextStyle(color: Colors.red)),
          TextFormField( 
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ), 
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter a valid email address.';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                  return 'Please enter a valid email address.';
                  }
                  if(registrationError?.errorType == 'email') {
                    return registrationError?.message;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                controller: passwordController,
                validator: (value) {
                  if(registrationError?.errorType == 'password') {
                    return registrationError?.message;
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      userServ.addUser(credential.user?.displayName, credential.user?.email, credential.user?.uid);
                      GoRouter.of(context).go('/');
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        registrationError = userServ.getAuthException(e.code);
                      });
                    }
                  }
                },
                child: Text('Register'),
              ),
              const Row(children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text("OR"),
                ),
                Expanded(child: Divider()),
              ]),
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text("Login"),
              ),
        ],
      ),
    );
  }
}