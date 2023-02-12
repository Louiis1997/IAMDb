import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../common/utils.dart';
import '../main.dart';
import '../components/episodes_list.dart';
import '../components/anime_information.dart';
import '../models/anime.dart';
import '../models/episode.dart';
import '../services/agenda.dart';
import '../services/anime.dart';

class AnimeDetail extends StatefulWidget {
  final int animeId;

  const AnimeDetail({Key? key, required this.animeId}) : super(key: key);

  static const String routeName = '/anime_detail';

  static void navigateTo(BuildContext context, int id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  static const List<Tab> animeDetailTabs = <Tab>[
    Tab(
      text: 'Information',
    ),
    Tab(text: 'Episodes'),
  ];

  @override
  State<AnimeDetail> createState() => _AnimeDetailState();
}

class _AnimeDetailState extends State<AnimeDetail> {
  PanelController _pc = new PanelController();
  String _status = "Add to agenda";

  @override
  void initState() {
    _getStatus(widget.animeId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Detail'),
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        color: Theme.of(context).colorScheme.primary,
        controller: _pc,
        minHeight: 60,
        maxHeight: 280,
        panel: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Anime current status:"),
                TextButton(
                  onPressed: () => _pc.open(),
                  child: Text(
                    "Modify: ($_status)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text("Envie de voir"),
              value: _status == "Envie de voir 🤤",
              onChanged: (bool? value) =>
                  setState(() => _onChanged(value, "Envie de voir 🤤")),
              activeColor: Colors.orange,
              checkboxShape: const CircleBorder(),
              secondary: const Icon(
                Icons.access_time_outlined,
                color: Colors.orange,
              ),
            ),
            CheckboxListTile(
              title: const Text("En pause"),
              value: _status == "En pause 🤒",
              onChanged: (bool? value) =>
                  setState(() => _onChanged(value, "En pause 🤒")),
              activeColor: Colors.orange,
              checkboxShape: const CircleBorder(),
              secondary: const Icon(
                Icons.pause_circle_outline,
                color: Colors.red,
              ),
            ),
            CheckboxListTile(
              title: const Text("En cours"),
              value: _status == "En cours ⏳",
              onChanged: (bool? value) =>
                  setState(() => _onChanged(value, "En cours ⏳")),
              activeColor: Colors.orange,
              checkboxShape: const CircleBorder(),
              secondary: const Icon(
                Icons.play_circle_outline,
                color: Colors.green,
              ),
            ),
            CheckboxListTile(
              title: const Text("Terminés"),
              value: _status == "Terminés ✅",
              onChanged: (bool? value) =>
                  setState(() => _onChanged(value, "Terminés ✅")),
              activeColor: Colors.orange,
              checkboxShape: const CircleBorder(),
              secondary:
                  const Icon(Icons.check_circle_outline, color: Colors.blue),
            ),
          ],
        ),
        body: DefaultTabController(
          length: AnimeDetail.animeDetailTabs.length,
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints.expand(height: 50),
                child: Material(
                  color: Theme.of(context).colorScheme.background,
                  child: TabBar(
                    tabs: AnimeDetail.animeDetailTabs,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AnimeInformation(
                        future: _getAnime(widget.animeId),
                        animeId: widget.animeId),
                    EpisodeList(future: _getEpisodes(widget.animeId))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Anime> _getAnime(int animeId) async {
    final token = await storage.read(key: "token");
    return AnimeService.getAnimeById(token!, animeId);
  }

  Future<List<Episode>> _getEpisodes(int animeId) async {
    final token = await storage.read(key: "token");
    return AnimeService.getAnimeEpisodes(token!, animeId);
  }

  void _getStatus(String animeId) async {
    try {
      final token = await storage.read(key: "token");
      String status = await AgendaService.getAnimeStatus(token!, animeId);
      setState(() {
        if (status != "") {
          _status = status;
        }
      });
    } catch (err) {
      if (err.toString().contains("500")) {
        Utils.displayAlertDialog(context, "Error when getting the anime status",
            "Internal Server Error");
      } else {
        Utils.displayAlertDialog(
            context, "Error when getting the anime status", err.toString());
      }
    }
  }

  void _updateStatus() async {
    final token = await storage.read(key: "token");
    if (_status == "Add to agenda")
      await AgendaService.deleteAnimeStatus(token!, widget.animeId.toString());
    else
      await AgendaService.updateAgendaStatus(token!, widget.animeId, _status);
  }

  void _onChanged(bool? value, String status) {
    _status = value == true ? status : "Add to agenda";
    _updateStatus();
    _pc.close();
  }
}
