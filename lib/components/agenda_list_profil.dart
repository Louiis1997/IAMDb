import 'package:flutter/material.dart';
import 'package:iamdb/components/small_image_grid.dart';

class AgendaListProfil extends StatelessWidget {
  final Future<List<dynamic>> future;
  final String status;

  const AgendaListProfil({Key? key, required this.future, required this.status})
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
              int itemCount =
                  snapshot.data.length > 6 ? 6 : snapshot.data.length;
              if (data == null || data.isEmpty) {
                return Center(
                  child: Text(
                    'No anime added yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return Padding(
                // Marge de 10 pixels autour du contenu
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          this.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SmallImageGrid(
                      snapshot: snapshot,
                      itemCount: itemCount,
                      status: this.status,
                    ),
                  ],
                ),
              );
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
}
