import 'package:great_places_v2/screens/places_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../screens/add_places_screen.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlacesScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                    child: Text("Got no places yet, start adding some!")),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.isEmpty
                    ? ch!
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(greatPlaces.items[i].image)),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(
                              greatPlaces.items[i].location.address as String),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                PlaceDetailScreen.routeName,
                                arguments: greatPlaces.items[i].id);
                          },
                        ),
                      )),
      ),
    );
  }
}
