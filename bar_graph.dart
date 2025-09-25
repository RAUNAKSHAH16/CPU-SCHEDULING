import 'package:flutter/material.dart';
import '../models/process.dart';

class BarGraph extends StatelessWidget {
  final List<Process> processes;

  const BarGraph({super.key, required this.processes});

  @override
  Widget build(BuildContext context) {
    final validProcesses = processes.where((p) => p.turnaroundTime != null).toList();

    if (validProcesses.isEmpty) {
      return const Center(
        child: Text(
          'No valid process data to display.',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    double maxTAT = validProcesses
        .map((p) => p.turnaroundTime!)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    if (maxTAT == 0) maxTAT = 1;

    return SizedBox(
      height: 360,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: validProcesses.map((p) {
            final tat = p.turnaroundTime ?? 0;
            final ct = p.completionTime ?? 0;
            final wt = p.waitingTime ?? 0;
            final barHeight = (tat / maxTAT) * 200;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Process ID Avatar
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.tealAccent,
                    child: Text(
                      p.pid.replaceAll("P", ""),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bar animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: barHeight),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    builder: (context, value, _) {
                      return Container(
                        width: 34,
                        height: value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF6A11CB),
                              Color(0xFF2575FC),
                              Color(0xFFA1C4FD),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(2, 6),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Metric Boxes
                  Column(
                    children: [
                      _infoBox(label: "TAT", value: tat.toString()),
                      const SizedBox(height: 4),
                      _infoBox(label: "CT", value: ct.toString()),
                      const SizedBox(height: 4),
                      _infoBox(label: "WT", value: wt.toString()),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Reusable info box widget
  Widget _infoBox({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
