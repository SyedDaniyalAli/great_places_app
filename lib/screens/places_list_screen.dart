import 'package:flutter/material.dart';
import '../providers/great_places.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
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
                  child: const Text('Got no places yes, start adding some'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.item.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlaces.item.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              greatPlaces.item[i].image,
                            ),
                          ),
                          title: Text(
                            greatPlaces.item[i].title,
                          ),
                          subtitle: Text(greatPlaces.item[i].location.address),
                          onTap: () {
                            // Goto Detail Page ...
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
