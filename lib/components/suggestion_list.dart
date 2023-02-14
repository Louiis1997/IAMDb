import 'package:flutter/material.dart';

class SuggestionList extends StatelessWidget {
  final Future<List<dynamic>> future;
  final onTap;

  const SuggestionList({Key? key, required this.future, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderItem();
  }

  FutureBuilder buildFutureBuilderItem() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return Center(
                  child: Text(
                    'No anime or manga found',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              return buildSuggestionListView(snapshot.data);
            }
            if (snapshot.hasError) {
              return Center(child: Text('Sorry, couldn\'t load animes/mangas'));
            }
            return Center(child: Text('Sorry, couldn\'t load animes/mangas'));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SizedBox buildSuggestionListView(data) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if ((data[index].imageUrl).contains("manga")) {
                onTap(context, data[index]);
              } else {
                onTap(context, data[index].malId);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(data[index].imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      data[index].titleEnglish,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
