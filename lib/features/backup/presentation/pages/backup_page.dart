import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_checkbox.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';
import 'package:savepoint95/core/widgets/w95_text_input.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  // Variable lives HERE, so it remembers values between repaints
  bool _shouldCopyHiddenFiles = false;
  final TextEditingController _sourceController = TextEditingController();

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
                      onTap: () => print("Browse clicked"),
                      child: const Text("Browse..."),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                W95Checkbox(
                  label: "Copy hidden files",
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
                      onTap: () => print("Start Backup"),
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
              ],

              // input + button row
            ),
          ),
        ),
      ),
    );
  }
}
