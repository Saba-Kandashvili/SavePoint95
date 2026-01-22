import 'dart:io';

import 'package:file_picker/file_picker.dart';

class BackupService {
  // picker wrapper
  Future<String?> pickFolder() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  // copy logic
  Future<void> copyDirectory(String source, String destination) async {
    final sourceDir = Directory(source);

    // do not allow copying into itself
    if (destination.startsWith(source)) {
      throw Exception("Cannot backup a folder into itself!");
    }

    // check if source exists
    if (!await sourceDir.exists()) {
      throw Exception('Source directory does not exist');
    }

    // get list of all files/fodlers
    // TODO: RECURSIVE SHOUDL BE A CHECK WHEN CALLED OR IMMPLEMNT IS MANUALLY (IS IS NOW
    await for (var entity in sourceDir.list(recursive: false)) {
      // logic:
      // get th efile name
      // create a enw destination path string
      String entityName = entity.path.split(Platform.pathSeparator).last;
      String destPath = '$destination${Platform.pathSeparator}$entityName';

      if (entity is File) {
        // copy file
        await File(entity.path).copy(destPath);
      } else if (entity is Directory) {
        // create new directory
        await Directory(destPath).create();

        // recursive copy
        await copyDirectory(entity.path, destPath);
      }
    }
  }
}
