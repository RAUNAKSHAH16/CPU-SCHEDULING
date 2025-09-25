import 'package:flutter/material.dart';
import '../models/process.dart';

class GanttChart extends StatelessWidget {
  final List<Process> processes;
  final int highlightStep; // Current step to highlight

  const GanttChart({
    super.key,
    required this.processes,
    this.highlightStep = -1, // -1 = no highlight
  });

  @override
  Widget build(BuildContext context) {
    // Filter valid processes
    final validProcesses = processes
        .where((p) => p.startTime != null && p.completionTime != null)
        .toList();

    if (validProcesses.isEmpty) {
      return const Center(
        child: Text(
          'No valid scheduling data to display Gantt chart.',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: validProcesses.asMap().entries.map((entry) {
          final index = entry.key;
          final p = entry.value;
          final duration = p.completionTime! - p.startTime!;
          final width = duration * 40.0; // width per unit time
          final isCurrent = index == highlightStep;

          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: width),
            duration: const Duration(milliseconds: 700),
            builder: (context, double animatedWidth, child) {
              return Container(
                width: animatedWidth,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCurrent
                        ? [Colors.orange.shade400, Colors.red.shade400]
                        : [Colors.blue.shade400, Colors.purple.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                      isCurrent ? Colors.yellowAccent : Colors.lightGreenAccent,
                      radius: 14,
                      child: Text(
                        p.pid.replaceAll("P", ""),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${p.startTime} → ${p.completionTime}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
