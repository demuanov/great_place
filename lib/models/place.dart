import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Place {
  final String id;
  final String title;
  final String imagePath;

  Place({
    required this.title,
    required this.imagePath,
  }) : id = _uuid.v4();
}