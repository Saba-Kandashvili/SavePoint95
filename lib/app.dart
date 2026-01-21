import 'package:flutter/material.dart';
import 'package:savepoint95/features/backup/presentation/pages/backup_page.dart';

class SavePoint95 extends StatelessWidget {
  const SavePoint95({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BackupPage());
  }
}
