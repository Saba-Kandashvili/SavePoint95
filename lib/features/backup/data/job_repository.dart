import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:savepoint95/features/backup/domain/backup_job.dart';

class JobRepository {
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}${Platform.pathSeparator}savepoint95_jobs.json';
  }

  Future<void> saveJobs(List<BackupJob> jobs) async {
    final file = File(await _getFilePath());
    // list of objjects to list of maps
    final data = jobs.map((job) => job.toJson()).toList();
    // write as astring
    await file.writeAsString(jsonEncode(data));
  }

  Future<List<BackupJob>> loadJobs() async {
    try {
      final file = File(await _getFilePath());
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);

      return jsonList.map((json) => BackupJob.fromJson(json)).toList();
    } catch (e) {
      // if file is corrupt or empty, return empty list
      print("Error loading jobs: $e");
      return [];
    }
  }
}
