import 'package:flutter/material.dart';
import 'package:savepoint95/core/theme/app_colors.dart';
import 'package:savepoint95/core/widgets/w95_button.dart';
import 'package:savepoint95/core/widgets/w95_panel.dart';
import 'package:savepoint95/features/backup/domain/backup_job.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // mock data for now for ui testing
  List<BackupJob> jobs = [
    BackupJob(
      id: '1',
      name: 'Minecraft Server',
      sourcePath: 'C:\\Games\\Minecraft',
      destinationPaths: ['D:\\Backups'],
      status: 'Idle',
    ),
    BackupJob(
      id: '2',
      name: 'Uni Projects',
      sourcePath: 'C:\\Dev\\Uni',
      destinationPaths: ['E:\\Backups'],
      status: 'Last run: 2 hours ago',
    ),
  ];

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
                          W95Button(child: const Text("New Job"), onTap: () {}),
                          const SizedBox(width: 4),
                          W95Button(
                            child: const Text("Run Selected"),
                            onTap: () {},
                          ),
                          const SizedBox(width: 4),
                          W95Button(
                            child: const Text("Settings"),
                            onTap: () {},
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
                            return ListTile(
                              leading: const Icon(
                                Icons.save,
                                color: Colors.black,
                              ),
                              title: Text(
                                job.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(job.status),
                              dense: true,
                              // slection logic later
                              onTap: () {
                                print("Selected ${job.name}");
                              },
                            );
                          },
                        ),
                      ),
                    ),
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
      child: Text(label), // need to make them clickable later
    );
  }
}
