import 'package:flutter/material.dart';
import 'package:iamdb/services/user.dart';
import '../components/status_drop_down_button.dart';
import '../main.dart';
import '../common/utils.dart';
import '../common/validator.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const String routeName = '/edit_profile';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getUserProfil(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return _buildForm(snapshot.data);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Form _buildForm(data) {
    initializeControllers(data);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipOval(
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWdArwtZM3Gky98tefwUkAmTxS6KLSqI5NFg&usqp=CAU",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                'Edit your Profile',
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: StatusDropDownButton(onChanged: _onChanged),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: onClickEditButton,
                child: const Text(
                  'Edit',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClickEditButton() async {
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
        editProfile(
            _userNameController.text.trim(),
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _bioController.text.trim(),
            _birthdayController.text.trim(),
            _status);
        Navigator.pop(context);
      } catch (err) {
        if (err.toString().contains("500")) {
          Utils.displayAlertDialog(context, "Error during the Authentication",
              "Internal Server Error");
        } else {
          Utils.displayAlertDialog(
              context, "Error during the Authentication", err.toString());
        }
      }
    }
  }

  void initializeControllers(data) {
    _userNameController.text = data.username;
    _firstNameController.text = data.firstname;
    _lastNameController.text = data.lastname;
    _bioController.text = data.bio;
  }

  static void editProfile(
    String userName,
    String firstName,
    String lastName,
    String bio,
    String birthday,
    String status,
  ) async {
    final token = await storage.read(key: "token");
    UserService.updateUser(
      token!,
      userName,
      firstName,
      lastName,
      bio,
      birthday,
      status,
    );
  }

  void _onChanged(String choice) {
    setState(() {
      _status = choice;
    });
  }

  Future<dynamic> _getUserProfil() async {
    final token = await storage.read(key: "token");
    return await UserService.getUser(token!);
  }

/*Future _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }*/
}
