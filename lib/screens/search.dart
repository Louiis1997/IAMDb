import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                controller: _controller,
                /*onChanged: (text) {
              if (text != '') {
                setState(() {
                  _getUsers(text);
                });
              } else {
                setState(() {
                  _users.clear();
                });
              }
            },*/
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //Home.navigateTo(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      /*setState(() {
                    _users.clear();
                    _controller.clear();
                  });*/
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            /*Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return UserWidget(
                user: _users[index],
                onTap: () => _onPostTap(_users[index]),
              );
            },
          ),
        ),*/
          ],
        ),
      ),
    );
  }
}
