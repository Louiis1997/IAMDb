import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iamdb/components/status_drop_down_button.dart';
import 'package:iamdb/services/auth.dart';
import 'package:image_picker/image_picker.dart';

import '../common/utils.dart';
import '../common/validator.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                  child: ProfileImagePicker(
                      pickImage: _pickImage, imageFile: _imageFile),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Create your Account',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: _userNameController,
                    validator: (value) => Validator.validateForm(value ?? ""),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: (value) => Validator.validateForm(value ?? ""),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: (value) => Validator.validateForm(value ?? ""),
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) => Validator.validateEmail(value ?? ""),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: StatusDropDownButton(onChanged: _onChanged),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ),
      ),
    );
  }

  void onClickRegistrationButton() async {
    if (_formKey.currentState!.validate()) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Processing Data',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 1),
          ),
        );
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
        Login.navigateTo(context);
      } catch (err) {
        log("Error: $err");
        Utils.displayAlertDialog(
            context, "Error during the Registration", err.toString());
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
