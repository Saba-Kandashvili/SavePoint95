import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_checkbox.dart';
import 'package:savepoint95/core/widgets/w95_message_box.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';
import 'package:savepoint95/core/widgets/w95_progress_bar.dart';
import 'package:savepoint95/core/widgets/w95_text_input.dart';
import 'package:savepoint95/features/backup/data/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  // Variable lives HERE, so it remembers values between repaints
  bool _shouldCopyHiddenFiles = false;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final BackupService _backupService = BackupService();

  // helper to pick source directory
  void _pickSource() async {
    String? path = await _backupService.pickFolder();
    if (path != null) {
      setState(() {
        _sourceController.text = path;
      });
    }
  }

  // helper to pick destination directory
  void _pickDestination() async {
    String? path = await _backupService.pickFolder();
    if (path != null) {
      setState(() {
        _destinationController.text = path;
      });
    }
  }

  void _startBackup() async {
    String source = _sourceController.text;
    String destination = _destinationController.text;

    // validate inuts (text fields empty?)

    if (source.isEmpty || destination.isEmpty) {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select both source and destination directories.",
          ),
        ),
      );
      return;
    }

    // show a loding indicator maybe a bool
    try {
      // await _backupService.runJob(Job); //TODO: REMOVE THIS FILE PROBABLY
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backup completed successfully.")),
      );
    } catch (e) {
      // show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Backup failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.winTeal,
      body: Center(
        child: W95Panel(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Source Directory"),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Expanded(
                      child: W95TextInput(controller: _sourceController),
                    ),
                    const SizedBox(width: 8),
                    W95Button(
                      onTap: () => _pickSource(),
                      child: const Text("Browse..."),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text("Destination Directory"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: W95TextInput(controller: _destinationController),
                    ),
                    const SizedBox(width: 8),
                    W95Button(
                      onTap: () => _pickDestination(),
                      child: const Text("Browse..."),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                W95Checkbox(
                  child: Text("Copy hidden files"),
                  value: _shouldCopyHiddenFiles,
                  onChanged: (val) {
                    setState(() {
                      // val can be null, so we default to false
                      _shouldCopyHiddenFiles = val ?? false;
                    });
                  },
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    W95Button(
                      onTap: () => _startBackup(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Start",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const Text("Current Progress:"),
                const SizedBox(height: 4),
                const W95ProgressBar(value: 0.65), // 65% filled

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    W95Button(
                      child: const Text("Test Error"),
                      onTap: () {
                        W95MessageBox.show(
                          context,
                          title: "Critical Error",
                          message:
                              "The flux capacitor is currently unmodified.",
                          type: MessageBoxType.error,
                        );
                      },
                    ),
                    W95Button(
                      child: const Text("Test Warning"),
                      onTap: () {
                        W95MessageBox.show(
                          context,
                          title: "Warning",
                          message: "The flux capacitor is about to overheat.",
                          type: MessageBoxType.warning,
                        );
                      },
                    ),
                    W95Button(
                      child: const Text("Test Info"),
                      onTap: () {
                        W95MessageBox.show(
                          context,
                          title: "Information",
                          message:
                              "The flux capacitor is operating within normal parameters.",
                          type: MessageBoxType.info,
                        );
                      },
                    ),
                  ],
                ),
              ],

              // input + button row
            ),
          ),
        ),
      ),
    );
  }
}
