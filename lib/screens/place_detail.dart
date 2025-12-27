import 'package:flutter/material.dart';
import 'package:great_place/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
        child: Text(
          'Details of the selected place will be shown here.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
