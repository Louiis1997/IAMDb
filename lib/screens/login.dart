import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../common/validator.dart';
import '../main.dart';
import '../models/user.dart';
//import '../services/auth.dart';
//import '../services/user.dart';
import 'home.dart';
import 'signup.dart';

//TODO Waiting API

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  //final AuthService _authService = AuthService();
  //final UserService _userService = UserService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = true;

  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(MyApp.title)),
        body: SingleChildScrollView(
            child: _futureUser == null
                ? buildFormLogin()
                : buildFutureBuilderLogin()));
  }

  Form buildFormLogin() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                MyApp.title,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  return Validator.validateEmail(value ?? "");
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: _showPassword,
                controller: _passwordController,
                validator: (value) {
                  return Validator.validatePassword(value ?? "");
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                    child: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: onClickLoginButton,
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<User> buildFutureBuilderLogin() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              Utils.displayAlertDialog(
                  context, "Error", "Error during the Authentication");
              return buildFormLogin();
            }
            if (!snapshot.hasData) {
              Utils.displayAlertDialog(context, "Error", "User not found");
              return buildFormLogin();
            }
            Utils.displayAlertDialog(context, "Success", "Authentication");
            Navigator.of(context).pushReplacementNamed(Home.routeName);
            return Text(snapshot.data!.email);
          default:
            return const Text("Authentication");
        }
      },
    );
  }

  void onClickLoginButton() async {
    Navigator.of(context).pushReplacementNamed(
      Home.routeName,
    );
    /*if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> response = await _authService.login(
            _emailController.text.trim(), _passwordController.text.trim());
        await storage.write(key: "token", value: response["token"]);
        await storage.write(key: "userId", value: response["userId"]);
        User user = await _userService.getUserById(
            response["userId"], response["token"]);
      } catch (err) {
        log("Error: $err");
        Utils.displayAlertDialog(
            context, "Error during the Authentication", err.toString());
      }
    }*/
  }
}
