import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_place/models/place.dart';
import 'package:great_place/providers/user_places.dart';
import 'package:great_place/widgets/image_input.dart';
import 'package:great_place/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _savePlace() async {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty) {
      return;
    }

    try {
      await ref.read(userPlacesProvider.notifier).addPlace(
            Place(
              title: enteredTitle,
              image: _selectedImage!,
              location: _selectedLocation!,
            ),
        );

      if (!mounted) return;
    Navigator.of(context).pop();
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Failed to access device storage path (path_provider).',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            ImageInput(onSelectImage: (image) {
              _selectedImage = image;
            }),
            const SizedBox(height: 10),
            LocationInput(onSelectLocation: (location) {
              _selectedLocation = location;
            }),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'))
          ],
        ),
      ),
    );
  }
}
