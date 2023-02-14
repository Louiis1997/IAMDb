import 'package:flutter/material.dart';
import 'package:iamdb/components/profile/profile_details.dart';

import '../components/profile/agenda_list_profile.dart';
import '../services/agenda.dart';

enum Status { enCours, enPause, envieDeVoir }

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  static const String routeName = '/profile';

  static const Map<Enum, String> status = {
    Status.enCours: "En cours ⏳",
    Status.enPause: "En pause 🤒",
    Status.envieDeVoir: "Envie de voir 🤤",
  };

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        children: [
          ProfileDetails(),
          AgendaListProfil(
            future: _getAgenda(status[Status.enCours]!),
            status: status[Status.enCours]!,
          ),
          AgendaListProfil(
            future: _getAgenda(status[Status.enPause]!),
            status: status[Status.enPause]!,
          ),
          AgendaListProfil(
            future: _getAgenda(status[Status.envieDeVoir]!),
            status: status[Status.envieDeVoir]!,
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _getAgenda(String status) async {
    return AgendaService.getAgendaByStatus(status);
  }
}
