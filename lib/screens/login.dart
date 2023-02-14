import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../exceptions/not-found.exception.dart';
import '../exceptions/unauthorized.exception.dart';
import '../common/user-interface-dialog.utils.dart';
import '../common/validators.dart';
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
  bool _isLoading = false;

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
        title: Image.asset(
          'assets/iamdb-logo.png',
          fit: BoxFit.contain,
          height: 64,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Sign in',
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                      ),
                    ),
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
                        }),
                        'assets/character.riv',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.visiblePassword,
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
              // Loading
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Visibility(
                  child: AlertDialog(
                    elevation: 500,
                    backgroundColor: Colors.transparent,
                    content: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  visible: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onClickLoginButton() async {
    passwordFocusNode.unfocus(disposition: disposition);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        Map<String, dynamic> response = await AuthService.login(
            _emailController.text.trim(), _passwordController.text.trim());
        await storage.write(key: "token", value: response["access_token"]);
        trigSuccess?.change(true);

        UserInterfaceDialog.displaySnackBar(
          context: context,
          message: "Login successful",
          messageType: MessageType.success,
        );
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      } catch (err) {
        if (err is UnauthorizedException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "The email or password you entered is incorrect",
            messageType: MessageType.error,
          );
        } else if (err is NotFoundException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "The email or password you entered is incorrect",
            messageType: MessageType.error,
          );
        } else {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                "Authentication failed, something went wrong. Please try again later or contact support",
            messageType: MessageType.error,
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
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
