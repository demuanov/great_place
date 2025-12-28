import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_place/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

  Future<sql.Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    state = data
        .map(
          (item) => Place(
            id: item['id'] as String?,
            title: item['title'] as String,
            image: File(item['image'] as String),
            location: item['loc_lat'] != null && item['loc_lng'] != null
                ? PlaceLocation(
                    latitude: item['loc_lat'] as double,
                    longitude: item['loc_lng'] as double,
                    address: item['address'] as String,
                  )
                : null,
          ),
        )
        .toList();
  }

  Future<void> addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image.path);

    final copiedImage = await place.image.copy('${appDir.path}/$fileName');
    final newPlace =
        Place(image: copiedImage, title: place.title, location: place.location);

    final db = await _getDatabase();

    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location?.latitude,
      'loc_lng': newPlace.location?.longitude,
      'address': newPlace.location?.address,
    });

    state = [
      newPlace,
      ...state,
    ];
  }
}

final userPlacesProvider =
    NotifierProvider<UserPlacesNotifier, List<Place>>(UserPlacesNotifier.new);
