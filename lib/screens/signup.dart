import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iamdb/exceptions/events/conflict.exception.dart';
import 'package:iamdb/exceptions/not-found.exception.dart';
import 'package:image_picker/image_picker.dart';

import '../components/status_drop_down_button.dart';
import '../services/auth.dart';
import '../common/user-interface-dialog.utils.dart';
import '../common/validators.dart';
import '../components/birthday_date_picker.dart';
import '../components/profile_image_picker.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  static const String routeName = '/signup';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _status = '';
  File? _imageFile;
  bool _isLoading = false;

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
                          'Sign up',
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                      ),
                    ),
                    Center(
                      child: ProfileImagePicker(
                          pickImage: _pickImage, imageFile: _imageFile),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _userNameController,
                        validator: (value) =>
                            Validator.validateForm(value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'john.doe',
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
                        controller: _firstNameController,
                        validator: (value) =>
                            Validator.validateForm(value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Firstname',
                          hintText: 'John',
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
                        controller: _lastNameController,
                        validator: (value) =>
                            Validator.validateForm(value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Lastname',
                          hintText: 'Doe',
                          filled: false,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _emailController,
                        validator: (value) =>
                            Validator.validateEmail(value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'john.doe@example.com',
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
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) =>
                            Validator.validatePassword(value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: '********',
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
                        obscureText: true,
                        controller: _passwordConfirmationController,
                        validator: (value) => Validator.validateConfirmPassword(
                            _passwordController.text, value ?? ""),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          hintText: '********',
                          filled: false,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      child: TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        maxLength: 150,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Biography',
                          hintText: 'I am a developer and I love Flutter!',
                          helperText: 'Enter a short biography of yourself',
                          filled: false,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: StatusDropDownButton(onChanged: _onChanged),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: BirthdayScrollDatePicker(
                        birthdayController: _birthdayController,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        onPressed: onClickRegistrationButton,
                        child: const Text(
                          'Sign up',
                        ),
                      ),
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

  void onClickRegistrationButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService.register(
            _userNameController.text.trim(),
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _bioController.text.trim(),
            _birthdayController.text.trim(),
            _status,
            _imageFile);
        UserInterfaceDialog.displaySnackBar(
          context: context,
          message: "Registration successful",
          messageType: MessageType.success,
        );
        await Future.delayed(Duration(seconds: 1));
        Login.navigateTo(context);
      } catch (err) {
        print("Error: $err");
        if (err is ConflictException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "This email or username is already used",
            messageType: MessageType.error,
          );
        } else if (err is NotFoundException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                "Failed to register (please try again or contact us if the problem persists))",
            messageType: MessageType.error,
          );
        } else if (err.toString().contains("500")) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                "Failed to register (please try again or contact us if the problem persists))",
            messageType: MessageType.error,
          );
        } else {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: err.toString(),
            messageType: MessageType.error,
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onChanged(String choice) {
    setState(() {
      _status = choice;
    });
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
}
