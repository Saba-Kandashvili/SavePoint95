import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_message_box.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';
import 'package:savepoint95/core/widgets/w95_progress_bar.dart';
import 'package:savepoint95/features/backup/data/backup_service.dart';
import 'package:savepoint95/features/backup/data/job_repository.dart';
import 'package:savepoint95/features/backup/domain/backup_job.dart';
import 'package:savepoint95/features/backup/presentation/dialogs/job_editor_dialog.dart';
import 'package:savepoint95/features/backup/presentation/pages/backup_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final JobRepository _repository = JobRepository();
  List<BackupJob> jobs = [];
  final BackupService _service = BackupService();
  bool _isLoading = true;
  String? _selectedJobId;
  double _currentProgress = 0.0;
  String? _currentStatusText;

  @override
  void initState() {
    super.initState();
    _loadData(); // load on startup
  }

  Future<void> _loadData() async {
    final loadedJobs = await _repository.loadJobs();
    setState(() {
      jobs = loadedJobs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.winTeal,
      body: Column(
        children: [
          // simlified meny bar for now
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                _buildMenuItem("File"),
                _buildMenuItem("Edit"),
                _buildMenuItem("Help"),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: W95Panel(
                child: Column(
                  children: [
                    // toolbar buttons
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          W95Button.text(
                            label: "New Job",
                            onTap: () async {
                              // open and await for results
                              final newJob = await showDialog<BackupJob>(
                                context: context,
                                builder: (context) => const JobEditorDialog(),
                              );
                              // if result came back (User didn't click Cancel)
                              if (newJob != null) {
                                setState(() {
                                  jobs.add(newJob); // update ui
                                });
                                _repository.saveJobs(jobs); // save to disk
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          W95Button.text(
                            label: "Run Selected",
                            onTap: () async {
                              // validation
                              if (_selectedJobId == null) {
                                W95MessageBox.show(
                                  context,
                                  title: "Error",
                                  message: "Please select a job first.",
                                  type: MessageBoxType.warning,
                                );
                                return;
                              }

                              // find job object
                              final job = jobs.firstWhere(
                                (j) => j.id == _selectedJobId,
                              );

                              // simple loadeend feedback (TODO: make real alter)
                              setState(() => _isLoading = true);
                              try {
                                // loop through EVERY destination in th elist
                                _service.runJob(job).listen(
                                  (status) {
                                    setState(() {
                                      _currentProgress = status.progress;
                                      _currentStatusText = status.currentFile;

                                      if (status.error != null) {
                                        // show error box
                                        W95MessageBox.show(
                                          context,
                                          title: "Backup Error",
                                          message: status.error!,
                                          type: MessageBoxType.error,
                                        );
                                      }
                                    });
                                  },
                                  onDone: () {
                                    setState((){
                                      _isLoading = false;
                                      job.lastRun = DateTime.now();
                                      job.status = "Success";
                                    });
                                  },
                                );
                              } catch (e) {
                                setState(() {
                                  job.status = "Failed";
                                  _isLoading = false;
                                });

                                if (mounted) {
                                  W95MessageBox.show(
                                    context,
                                    title: "Backup Failed",
                                    message: e.toString(),
                                    type: MessageBoxType.error,
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          W95Button.text(
                            label: "Settings",
                            onTap: () {},
                          ),
                          const SizedBox(width: 4),
                          W95Button.text(
                            label: "Backup",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BackupPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            // sunken Border Logic
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
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            final isSelected = _selectedJobId == job.id;

                            return Container(
                              color: isSelected
                                  ? AppColors.winBlue
                                  : Colors.transparent,
                              child: ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.save,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                title: Text(
                                  job.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  job.status,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedJobId = job.id;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    if (_isLoading) ...[
                      const SizedBox(height: 8),
                      W95ProgressBar(value: _currentProgress, showPercentage: true),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(label, style: const TextStyle(fontFamily: 'MS W98 UI')), // need to make them clickable later
    );
  }
}
