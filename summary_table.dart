import 'package:flutter/material.dart';
import '../models/process.dart';

class SummaryTable extends StatelessWidget {
  final List<Process> processes;

  const SummaryTable({super.key, required this.processes});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.deepPurple.shade200,
        ),
        dataRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.deepPurple.shade50,
        ),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
        dataTextStyle: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
        ),
        columns: const [
          DataColumn(label: Text('PID')),
          DataColumn(label: Text('Arrival')),
          DataColumn(label: Text('Burst')),
          DataColumn(label: Text('Start')),
          DataColumn(label: Text('Completion')),
          DataColumn(label: Text('TAT')),
          DataColumn(label: Text('WT')),
        ],
        rows: processes.map((p) {
          return DataRow(
            cells: [
              DataCell(_animatedCell('P${p.pid}')),
              DataCell(_animatedCell('${p.arrivalTime}')),
              DataCell(_animatedCell('${p.burstTime}')),
              DataCell(_animatedCell('${p.startTime}')),
              DataCell(_animatedCell('${p.completionTime}')),
              DataCell(_animatedCell('${p.turnaroundTime}')),
              DataCell(_animatedCell('${p.waitingTime}')),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Helper widget for animated cell
  static Widget _animatedCell(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: Text(text),
    );
  }
}
