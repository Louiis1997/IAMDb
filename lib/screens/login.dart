import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../exceptions/not-found.exception.dart';
import '../exceptions/unauthorized.exception.dart';
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
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  UnfocusDisposition disposition = UnfocusDisposition.scope;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
  }

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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    child: RiveAnimation.asset(
                        stateMachines: const ["Login Machine"],
                        onInit: ((artboard) {
                          controller = StateMachineController.fromArtboard(
                              artboard, "Login Machine");
                          if (controller == null) return;
                          artboard.addController(controller!);
                          isChecking = controller?.findInput("isChecking");
                          numLook = controller?.findInput("numLook");
                          isHandsUp = controller?.findInput("isHandsUp");
                          trigSuccess = controller?.findInput("trigSuccess");
                          trigFail = controller?.findInput("trigFail");
                        }), 'assets/character.riv'),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    focusNode: emailFocusNode,
                    onChanged: (value) {
                      numLook?.change(value.length.toDouble());
                    },
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    focusNode: passwordFocusNode,
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
                      child: const Text('Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
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
    await Future.delayed(Duration(seconds: 1));
    passwordFocusNode.unfocus(disposition: disposition);
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
        trigSuccess?.change(true);
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      } catch (err) {
        if (err is UnauthorizedException) {
          Utils.displayAlertDialog(
            context,
            "Authentication failed",
            "The email or password you entered is incorrect",
          );
        } else if (err is NotFoundException) {
          Utils.displayAlertDialog(
            context,
            "Authentication failed",
            "The email or password you entered is incorrect",
          );
        } else {
          Utils.displayAlertDialog(
            context,
            "Authentication failed",
            "Something went wrong",
          );
        }
      }
    }
    trigFail?.change(true);
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }
}
