import 'dart:developer';

import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../common/validator.dart';
import '../main.dart';
import '../services/auth.dart';
import 'home.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String routeName = '/login';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      // Image of the app
                      Image.asset(
                        'images/iamdb-logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      return Validator.validateEmail(value ?? "");
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email address',
                      hintText: 'john.doe@example.com',
                      helperText: 'Enter your email address',
                      filled: false,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    obscureText: _showPassword,
                    controller: _passwordController,
                    validator: (value) {
                      return Validator.validatePassword(value ?? "");
                    },
                    decoration: InputDecoration(
                      filled: false,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: '********',
                      helperText: 'Enter your password',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: onClickLoginButton,
                    child: const Text(
                      'Login',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Don\'t have an account yet?',
                    ),
                    TextButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      onPressed: () {
                        Signup.navigateTo(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onClickLoginButton() async {
    if (_formKey.currentState!.validate()) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Processing Data',
                style: Theme.of(context).textTheme.bodyText1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 1),
          ),
        );
        Map<String, dynamic> response = await AuthService.login(
            _emailController.text.trim(), _passwordController.text.trim());
        await storage.write(key: "token", value: response["access_token"]);
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      } catch (err) {
        log("Error: $err");
        Utils.displayAlertDialog(
            context, "Error during the Authentication", err.toString());
      }
    }
  }
}
