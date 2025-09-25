import 'package:flutter/material.dart';
import '../models/process.dart';
import '../widgets/gantt_chart.dart';

class SimulationScreen extends StatefulWidget {
  final List<Process> processes;
  final String algorithm;
  final int? quantum;

  const SimulationScreen({
    super.key,
    required this.processes,
    required this.algorithm,
    this.quantum,
  });

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int currentStep = 0; // Tracks which step we are on
  bool isPlaying = false;
  List<Map<String, dynamic>> timeline = []; // Step timeline

  @override
  void initState() {
    super.initState();
    _generateTimeline(); // Precompute steps for simulation
  }

  void _generateTimeline() {
    int time = 0;
    for (var process in widget.processes) {
      int start = time > process.arrivalTime ? time : process.arrivalTime;
      int end = start + process.burstTime;
      timeline.add({'pid': process.pid, 'start': start, 'end': end});
      time = end;
    }
  }

  void _nextStep() {
    if (currentStep < timeline.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _play() {
    isPlaying = true;
    Future.doWhile(() async {
      if (!isPlaying || currentStep >= timeline.length - 1) return false;
      await Future.delayed(const Duration(seconds: 1));
      _nextStep();
      return true;
    });
  }

  void _pause() {
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepsToShow = timeline.sublist(0, currentStep + 1);

    return Scaffold(
      appBar: AppBar(title: Text("${widget.algorithm} Simulation")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("Step: ${currentStep + 1}/${timeline.length}"),
            const SizedBox(height: 20),

            // Wrap GanttChart in horizontal scroll and fixed height
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GanttChart(
                  processes: widget.processes,
                  highlightStep: currentStep,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Step controls in Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _previousStep, child: const Text("Prev")),
                ElevatedButton(onPressed: _play, child: const Text("Play")),
                ElevatedButton(onPressed: _pause, child: const Text("Pause")),
                ElevatedButton(onPressed: _nextStep, child: const Text("Next")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
