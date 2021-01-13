import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImage extends StatefulWidget {
  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  // File _image;
  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: _image == null ? Text('No image selected.') : Image.file(_image),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.add_a_photo),
  //       onPressed: getImage,
  //     ),
  //   );
  // }

  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    if (Platform.isAndroid) {
      retrieveLostData();
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Semantics(
          child: Image.file(File(_imageFile.path)),
          label: 'image_picker_example_picked_image');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      setState(() {
        _retrieveDataError = response.exception.code;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _previewImage(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo_library),
        onPressed: () async {
          try {
            final pickedFile = await _picker.getImage(
              source: ImageSource.gallery,
            );
            setState(() {
              _imageFile = pickedFile;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        },
      ),
    );
  }
}
