import 'dart:developer';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/user-interface-dialog.utils.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../screens/login.dart';
import '../../services/user.dart';

final profileUpdatedProvider = StateProvider((ref) => false);

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _changed = ref.watch(profileUpdatedProvider);
    return buildFutureBuilderProfileDetails(_changed);
  }

  FutureBuilder buildFutureBuilderProfileDetails(bool _changed) {
    return FutureBuilder(
      future: _changed ? _getUserProfil() : _getUserProfil(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final User user = snapshot.data;
              if (user.isEmpty()) {
                return Center(
                  child: Text(
                    'No profile found.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(200, 200, 200, 1),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                          ),
                          Container(
                            color: Theme.of(context).cardColor,
                            height: 150,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipOval(
                                      child: Image.network(
                                        '${user.profilePictureUrl != "" ? user.profilePictureUrl : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWdArwtZM3Gky98tefwUkAmTxS6KLSqI5NFg&usqp=CAU"}',
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${user.username.toUpperCase()}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${user.bio == null ? '' : user.bio}',
                                  style: GoogleFonts.aBeeZee(
                                    textStyle: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${user.status}',
                                  style: GoogleFonts.aBeeZee(
                                    textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: FloatingActionButton(
                                onPressed: () async {
                                  selectParam(context);
                                },
                                child: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text("Sorry, couldn't load the profile."));
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Future selectParam(context) {
    return showAdaptiveActionSheet(
      context: context,
      title: const Text('Parametres'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Text(
              'Edit profile',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onPressed: (context) {
              Navigator.popAndPushNamed(context, '/edit_profile');
            }),
        BottomSheetAction(
            title: Text(
              'Disconnect',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onPressed: (context) {
              disconnect(context);
            }),
        BottomSheetAction(
            title: Text(
              'Remove account',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Color.fromRGBO(230, 0, 0, 1),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            onPressed: (context) {
              deleteAccount(context);
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  Future<void> disconnect(context) async {
    await storage.delete(key: "token");
    await storage.delete(key: "userId");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  void deleteAccount(context) async {
    try {
      var token = await storage.read(key: "token");
      await UserService.delete(token!);
      await storage.delete(key: "token");
      await storage.delete(key: "userId");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } catch (err) {
      log("Error: $err");
      UserInterfaceDialog.displayAlertDialog(
          context, "Error during the deleting of the account", err.toString());
    }
  }

  Future<dynamic> _getUserProfil() async {
    final token = await storage.read(key: "token");
    return await UserService.getUser(token!);
  }
}
