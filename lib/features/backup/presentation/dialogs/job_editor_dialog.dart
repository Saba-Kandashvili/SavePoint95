import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_checkbox.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';
import 'package:savepoint95/core/widgets/w95_text_input.dart';
import 'package:savepoint95/features/backup/data/backup_service.dart';
import 'package:savepoint95/features/backup/domain/backup_job.dart';

class JobEditorDialog extends StatefulWidget {
  final BackupJob? job; // null if creating new
  const JobEditorDialog({super.key, this.job});

  @override
  State<JobEditorDialog> createState() => _JobEditorDialogState();
}

class _JobEditorDialogState extends State<JobEditorDialog> {
  // contorllers
  final _nameController = TextEditingController();
  final _sourceController = TextEditingController();

  // state fo tthe desttination lsit
  List<String> _destinations = [];
  String? _selectedDestination; // currenlty highlited in th elist

  // setting state
  bool _zipFiles = false;
  bool _atomicMode = true;

  @override
  void initState() {
    // if editing fill the fileds with existign data
    if (widget.job != null) {
      _nameController.text = widget.job!.name;
      _sourceController.text = widget.job!.sourcePath;
      _destinations = List.from(widget.job!.destinationPaths); // copy list
      _zipFiles = widget.job!.zipFiles;
      _atomicMode = widget.job!.atomicMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      child: W95Panel(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              const Text(
                "Job Configuration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // job name
              const Text("Job Name:"),
              W95TextInput(controller: _nameController),
              const SizedBox(height: 12),

              // source
              const Text("Source Fodler:"),
              Row(
                children: [
                  Expanded(child: W95TextInput(controller: _sourceController)),
                  const SizedBox(width: 8),
                  W95Button(
                    onTap: () => _pickeSource(),
                    child: const Text("..."),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // destination list maneger
              const Text("Destination Drivers/Folders:"),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    // sunken Border
                    top: const BorderSide(
                      color: AppColors.darkShadow,
                      width: 2,
                    ),
                    left: const BorderSide(
                      color: AppColors.darkShadow,
                      width: 2,
                    ),
                    right: const BorderSide(
                      color: AppColors.highlight,
                      width: 2,
                    ),
                    bottom: const BorderSide(
                      color: AppColors.highlight,
                      width: 2,
                    ),
                  ),
                ),
                child: ListView.builder(
                  itemCount: _destinations.length,
                  itemBuilder: (context, index) {
                    final path = _destinations[index];
                    final isSelected = _selectedDestination == path;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDestination = path),
                      child: Container(
                        color: isSelected ? AppColors.winTeal : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          path,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // button to manege the list
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  W95Button(
                    onTap: _addDestination,
                    child: const Text("Add..."),
                  ),
                  const SizedBox(width: 4),
                  W95Button(
                    onTap: _removeDestination,
                    child: const Text("Remove"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // option toogles
              Row(
                children: [
                  W95Checkbox(
                    child: Text("Zip Compression"),
                    value: _zipFiles,
                    onChanged: (v) => setState(() => _zipFiles = v!),
                  ),

                  const SizedBox(width: 16),

                  W95Checkbox(
                    child: Text("Atomic Mode (Safe)"),
                    value: _atomicMode,
                    onChanged: (v) => setState(() => _atomicMode = v!),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // footer buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  W95Button(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OK",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      if (_nameController.text.isEmpty ||
                          _sourceController.text.isEmpty) {
                        return;
                      }

                      // create the object
                      final job = BackupJob(
                        // if editing keep the same id
                        id:
                            widget.job?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        sourcePath: _sourceController.text,
                        destinationPaths: _destinations,
                        zipFiles: _zipFiles,
                        atomicMode: _atomicMode,
                        // default trigegrs for now
                      );

                      // close dialog AND pass the job back
                      Navigator.pop(context, job);
                    },
                  ),
                  const SizedBox(width: 8),
                  W95Button(
                    onTap: () => Navigator.pop(context), // Close without saving
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickeSource() async {
    // reuse backend BackupService folder picker
    String? path = await BackupService().pickFolder();
    if (path != null) {
      setState(() {
        _sourceController.text = path;
      });
    }
  }

  void _addDestination() async {
    String? path = await BackupService().pickFolder();
    if (path != null) {
      setState(() {
        _destinations.add(path);
      });
    }
  }

  void _removeDestination() {
    if (_selectedDestination != null) {
      setState(() {
        _destinations.remove(_selectedDestination);
        _selectedDestination = null;
      });
    }
  }
}
