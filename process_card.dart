import 'package:flutter/material.dart';
import '../models/process.dart';

class ProcessCard extends StatelessWidget {
  final Process process;
  final VoidCallback onDelete;
  final bool showPriority;

  const ProcessCard({
    super.key,
    required this.process,
    required this.onDelete,
    this.showPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          '${process.pid} (AT: ${process.arrivalTime}, BT: ${process.burstTime}'
              '${showPriority && process.priority != null ? ', PR: ${process.priority}' : ''})',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
