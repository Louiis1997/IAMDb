import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/agenda.dart';
import '../services/agenda.dart';
import '../main.dart';
import '../models/anime.dart';

class AnimeCard extends ConsumerStatefulWidget {
  final Anime anime;
  final Function() onTap;

  const AnimeCard({Key? key, required this.anime, required this.onTap})
      : super(key: key);

  @override
  AnimeCardState createState() => AnimeCardState();
}

class AnimeCardState extends ConsumerState<AnimeCard> {
  String _status = "";

  @override
  void initState() {
    _getStatus(widget.anime.malId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.grey),
          ),
          child: GestureDetector(
            onTap: () => widget.onTap(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(45)),
                  child: Image.network(
                    widget.anime.imageUrl ?? "",
                    width: maxWidth * .2,
                    height: MediaQuery.of(context).size.height * .1,
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: maxWidth * .58,
                      child: Text(
                        widget.anime.titleEnglish ?? widget.anime.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.anime.episodes} episodes",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _showModalBottomSheet();
                  },
                  icon: _icon(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 250,
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxListTile(
                    title: const Text("Envie de voir"),
                    value: _status == "Envie de voir 🤤",
                    onChanged: (bool? value) => setState(() => _onChanged(value, "Envie de voir 🤤")),
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
                    onChanged: (bool? value) => setState(() => _onChanged(value, "En pause 🤒")),
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
                    onChanged: (bool? value) => setState(() => _onChanged(value, "En cours ⏳")),
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
                    onChanged: (bool? value) => setState(() => _onChanged(value, "Terminés ✅")),
                    activeColor: Colors.orange,
                    checkboxShape: const CircleBorder(),
                    secondary: const Icon(Icons.check_circle_outline,
                        color: Colors.blue),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() => _updateStatus());
  }

  void _getStatus(String animeId) async {
    final token = await storage.read(key: "token");
    String status = await AgendaService.getAnimeStatus(token!, animeId);
    setState(() {
      _status = status;
    });
  }

  void _updateStatus() async {
    final token = await storage.read(key: "token");
    if (_status == "")
      await AgendaService.deleteAnimeStatus(
          token!, widget.anime.malId.toString());
    else
      await AgendaService.updateAgendaStatus(
          token!, widget.anime.malId, _status);
    ref.read(boolProvider.notifier).state = !ref.watch(boolProvider);
  }

  Icon _icon() {
    if (_status == "Terminés ✅") {
      return Icon(Icons.check_circle_outline, color: Colors.blue);
    } else if (_status == "En cours ⏳") {
      return Icon(Icons.play_circle_outline, color: Colors.green);
    } else if (_status == "En pause 🤒") {
      return Icon(Icons.pause_circle_outline, color: Colors.red);
    } else if (_status == "Envie de voir 🤤") {
      return Icon(Icons.access_time_outlined, color: Colors.orange);
    }
    return Icon(Icons.add_circle_outline);
  }

  void _onChanged(bool? value, String status) {
    _status = value == true ? status : "";
  }
}
