import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Directory? _imagesDirectory;

/// Get directory for app Images private storage
Future<Directory> getImagesDirectoryPath() async {
  Directory? theImagesDirectory = _imagesDirectory;
  if (theImagesDirectory != null) {
    return theImagesDirectory;
  }

  final Directory directory = await getApplicationSupportDirectory();

  final Directory imagesDirectory = Directory(join(directory.path, 'images'));

  if (!await imagesDirectory.exists()) {
    await imagesDirectory.create(recursive: true);
  }

  _imagesDirectory = imagesDirectory;

  return imagesDirectory;
}

class ImagesDirectoryImageWidget extends StatelessWidget {
  final String image;
  final BoxFit? fit;

  /// ImagesDirectoryImageWidget initialization
  ImagesDirectoryImageWidget({
    required this.image,
    this.fit,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final imagesDirectory = _imagesDirectory;
    if (imagesDirectory != null) {
      return Image.file(
        File(join(imagesDirectory.path, image)),
        fit: fit,
      );
    }

    return FutureBuilder<Directory>(
      future: getImagesDirectoryPath(),
      builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
        final imagesDirectory = snapshot.data;
        if (imagesDirectory != null) {
          return Image.file(
            File(join(imagesDirectory.path, image)),
            fit: fit,
          );
        }

        return Container();
      },
    );
  }
}
