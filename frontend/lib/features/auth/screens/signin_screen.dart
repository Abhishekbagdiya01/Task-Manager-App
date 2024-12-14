import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "E-mail"),
                    validator: (value) {
                      if (value!.trim().isEmpty ||
                          !value.trim().contains("@gmail.com")) {
                        return "Please enter valid email";
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim().length <= 6) {
                        return "Please enter valid password";
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                      }
                    },
                    child: const Text("Login",
                        style: TextStyle(fontSize: 20, color: Colors.white))),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.titleMedium,
                        text: "Don't have an account ? ",
                        children: const [TextSpan(text: "Sign-up")]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
