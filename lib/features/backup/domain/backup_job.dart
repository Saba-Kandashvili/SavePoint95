class BackupJob {
  final String id;
  String name; // "Minecraft Server"
  String sourcePath; // "C:\Minecraft\Server"
  List<String> destinationPaths; // ["D:\Backup", "E:\Backup"]

  // settings
  bool zipFiles;
  bool copyHiddenFiles;
  bool atomicMode; // copy all or nothing

  // triggers
  bool runOnIdle; // run when system is idle
  int intervalMinutes; // run every X minutes, 0 = disabled

  // status jsut for ui
  DateTime? lastRun;
  String status; // idle, running, error, success

  BackupJob({
    required this.id,
    required this.name,
    required this.sourcePath,
    required this.destinationPaths,
    this.zipFiles = false,
    this.copyHiddenFiles = false,
    this.atomicMode = true,
    this.runOnIdle = false,
    this.intervalMinutes = 0,
    this.lastRun,
    this.status = "idle",
  });

  // TODO: toJson, fromJson methods for storage
}
