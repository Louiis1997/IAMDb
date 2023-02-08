import 'package:flutter/material.dart';

import '../screens/anime_detail.dart';

class AgendaList extends StatelessWidget {
  final Future<List<dynamic>> future;

  const AgendaList({Key? key, required this.future}) : super(key: key);

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
                return const Center(child: Text('No data'));
              }
              return buildAgendaListView(snapshot.data);
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Text('${snapshot.error}');
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SizedBox buildAgendaListView(data) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              AnimeDetail.navigateTo(context, data[index].malId);
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
        scrollDirection: Axis.vertical,
      ),
    );
  }
}