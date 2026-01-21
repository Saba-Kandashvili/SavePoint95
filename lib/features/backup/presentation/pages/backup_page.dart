import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_checkbox.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  // Variable lives HERE, so it remembers values between repaints
  bool _shouldCopyHiddenFiles = false;

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
              children: [
                const Text(
                  "Backup Wizard",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                W95Button(
                  child: const Text("YAY!"),
                  onTap: () {
                    print("Backup started");
                  },
                ),
                const SizedBox(height: 10.0),
                W95Checkbox(
                  value: _shouldCopyHiddenFiles,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _shouldCopyHiddenFiles = newValue ?? false;
                    });
                  },
                  label: "Copy Hidden files",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
