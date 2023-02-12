import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../screens/anime_detail.dart';
import '../services/anime.dart';
import '../common/debouncer.dart';
import '../components/anime_card.dart';
import '../main.dart';
import '../models/anime.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();

  static const String routeName = '/search';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 1000);
  final List<String> _filters = [
    "Tv",
    "Movie",
    "Ova",
    "Special",
    "Ona",
    "Music"
  ];
  List<Anime> _animes = [];
  String _filter = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    onChanged: _onChanged(),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: false,
                      prefixIcon: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _animes.clear();
                            _controller.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _filters
                        .map(
                          (type) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _filter == type
                                    ? Theme.of(context).primaryColor
                                    : Color.fromRGBO(240, 240, 240, 0.8),
                              ),
                              onPressed: () {
                                _onPressed(type);
                              },
                              child: Text(type),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _animes.length,
                    itemBuilder: (context, index) {
                      return AnimeCard(
                        anime: _animes[index],
                        onTap: () => {
                          AnimeDetail.navigateTo(context, _animes[index].malId)
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
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
    );
  }

  void _getAnimes(String name, String filter) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final token = await storage.read(key: "token");
      var response = await AnimeService.search(token!, name, filter);
      setState(() {
        _animes = response;
      });
    } catch (err) {
      if (err.toString().contains("500")) {
        Utils.displaySnackBar(
            context: context,
            message: "Internal Server Error",
            messageType: MessageType.error);
      } else {
        Utils.displaySnackBar(
            context: context,
            message:
                "An error occurred while searching. Please try again later or contact us.",
            messageType: MessageType.error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void Function(String) _onChanged() {
    return (String text) {
      _debouncer.run(() {
        if (text != '') {
          setState(() {
            _getAnimes(text.trim(), _filter);
          });
        } else {
          setState(() {
            _animes.clear();
          });
        }
      });
    };
  }

  void _onPressed(String filter) {
    if (_controller.text != '') {
      setState(() {
        _filter = filter;
        _getAnimes(_controller.text.trim(), filter);
      });
    } else {
      setState(() {
        _filter = filter;
      });
    }
  }
}
