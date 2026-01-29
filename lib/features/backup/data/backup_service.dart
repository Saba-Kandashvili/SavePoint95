import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:savepoint95/features/backup/domain/backup_job.dart';
import 'package:savepoint95/features/backup/domain/backup_status.dart';

class BackupService {
  // picker wrapper
  Future<String?> pickFolder() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  Stream<BackupStatus> runJob(BackupJob job) async* {
    final sourceDir = Directory(job.sourcePath);

    // validation
    if (!await sourceDir.exists()) {
      yield BackupStatus(
        progress: 0,
        currentFile: "Error: Source not found",
        error: "Source missing",
      );
      return;
    }

    // scan the files to calulate progress
    yield BackupStatus(progress: 0, currentFile: "Scanning files...");

    // need a list of all files to knkow "Total FIles"
    final List<FileSystemEntity> files = await sourceDir
        .list(recursive: true)
        .toList();
    final int totalFiles = files
        .whereType<File>()
        .length; // only files not directories
    int processedFiles = 0;

    // execution loop
    for (String destPath in job.destinationPaths) {
      try {
        final String folderName = job.sourcePath
            .split(Platform.pathSeparator)
            .last;

        if (job.zipFiles) {
          final String tempZip =
              "$destPath${Platform.pathSeparator}$folderName.zip.tmp";
          final String finalZip =
              "$destPath${Platform.pathSeparator}$folderName.zip";

          // cleanup previous runs
          if (await File(tempZip).exists()) {
            await File(tempZip).delete();
          }
          if (await File(finalZip).exists()) {
            await File(finalZip).delete();
          }

          // initialise encoder
          var encoder = ZipFileEncoder();
          encoder.create(tempZip);

          for (var entity in files) {
            if (entity is File) {
              // get path realtive to sorce
              // need the zip to contain the fikder structures not aboslute paths
              final String relativePath = entity.path.substring(
                sourceDir.path.length + 1,
              );

              yield BackupStatus(
                progress:
                    processedFiles / (totalFiles * job.destinationPaths.length),
                currentFile: "Zipping: $relativePath...",
              );

              // add to zip
              // await here but note that addFile is technically synchronous CPU work
              await encoder.addFile(entity, relativePath);
              processedFiles++;
            }
          }

          encoder.close();

          // rename .tmp to final
          await File(tempZip).rename(finalZip);
        }
        // branch b standard copy
        else {
          // atomic logic per destination
          final String tempDest =
              "$destPath${Platform.pathSeparator}$folderName.tmp";
          final String finalDest =
              "$destPath${Platform.pathSeparator}$folderName";

          // if tmp exist froma aprevious crush delete it
          if (await Directory(tempDest).exists()) {
            await Directory(tempDest).delete(recursive: true);
          }

          // create the .tmp root
          await Directory(tempDest).create(recursive: true);

          // file copy loop
          for (var entity in files) {
            if (entity is File) {
              // calculate relative apth
              final String relativePath = entity.path.substring(
                sourceDir.path.length + 1,
              );
              final String targetPath =
                  "$tempDest${Platform.pathSeparator}$relativePath";

              // emit progress
              yield BackupStatus(
                progress:
                    processedFiles / (totalFiles * job.destinationPaths.length),
                currentFile: "Copying: $relativePath to $destPath...",
              );

              // create parent directory if needed
              final parentDir = Directory(File(targetPath).parent.path);
              if (!await parentDir.exists()) {
                await parentDir.create(recursive: true);
              }

              // actual copy
              await entity.copy(targetPath);
              processedFiles++;
            }
          }

          // rename .tmp to actual name
          await Directory(tempDest).rename(finalDest);
        }
      } catch (e) {
        // if anythgin fails  yield erro and maybe cleanup .tmp
        yield BackupStatus(progress: 0, currentFile: "", error: e.toString());

        // cleanup logic TODO: logic
        return;
      }
    }

    yield BackupStatus(progress: 1.0, currentFile: "Backup Complete!");
  }
}
