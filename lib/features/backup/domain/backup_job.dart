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

  // convert object -> JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sourcePath': sourcePath,
      'destinationPaths':
          destinationPaths, // lists handles themselves automatically in JSON
      'zipFiles': zipFiles,
      'copyHiddenFiles': copyHiddenFiles,
      'atomicMode': atomicMode,
      'runOnIdle': runOnIdle,
      'intervalMinutes': intervalMinutes,
      'lastRun': lastRun?.toIso8601String(), // dates need explicit conversion
      'status': status,
    };
  }

  // convert JSON map -> object
  factory BackupJob.fromJson(Map<String, dynamic> json) {
    return BackupJob(
      id: json['id'],
      name: json['name'],
      sourcePath: json['sourcePath'],
      // JSON lists come back as generic 'List<dynamic>', we must cast them to String
      destinationPaths: List<String>.from(json['destinationPaths']),
      zipFiles: json['zipFiles'],
      copyHiddenFiles: json['copyHiddenFiles'],
      atomicMode: json['atomicMode'],
      runOnIdle: json['runOnIdle'],
      intervalMinutes: json['intervalMinutes'],
      // Parse the date string back to DateTime, if it exists
      lastRun: json['lastRun'] != null ? DateTime.parse(json['lastRun']) : null,
      status: json['status'] ?? 'Idle',
    );
  }
}
