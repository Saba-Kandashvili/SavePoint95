
class BackupStatus {
  final double progress; // 0.0 to 1.0
  final String currentFile;
  final bool isDone;
  final String? error;

  BackupStatus({
    required this.progress,
    required this.currentFile,
    this.isDone = false,
    this.error,
  });
}