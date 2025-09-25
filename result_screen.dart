import 'package:flutter/material.dart';
import '../models/process.dart';
import '../widgets/gantt_chart.dart';
import '../widgets/summary_table.dart';
import '../widgets/bar_graph.dart';

class ResultScreen extends StatefulWidget {
  final List<Process> processes;
  final String algorithm;
  final int? quantum;

  const ResultScreen({
    super.key,
    required this.processes,
    required this.algorithm,
    this.quantum,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _currentStep = 0;
  bool _isPlaying = false;

  void _playSimulation() {
    setState(() => _isPlaying = true);
    _nextStepRecursive();
  }

  void _pauseSimulation() {
    setState(() => _isPlaying = false);
  }

  void _nextStep() {
    if (_currentStep < widget.processes.length) {
      setState(() => _currentStep++);
    }
  }

  void _nextStepRecursive() async {
    if (!_isPlaying || _currentStep >= widget.processes.length) return;

    await Future.delayed(const Duration(seconds: 1));
    if (_isPlaying && _currentStep < widget.processes.length) {
      setState(() => _currentStep++);
      _nextStepRecursive();
    }
  }

  @override
  Widget build(BuildContext context) {
    final validProcesses = widget.processes
        .where((p) => p.startTime != null && p.completionTime != null)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.algorithm} - Result"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF283c86), Color(0xFF45a247)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: validProcesses.isEmpty
              ? const Center(
            child: Text(
              "No valid scheduling data available.\nMake sure processes are scheduled.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Algorithm Info Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Algorithm: ${widget.algorithm}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.algorithm == "Round Robin" &&
                            widget.quantum != null)
                          Text(
                            "Time Quantum: ${widget.quantum}",
                            style: const TextStyle(fontSize: 18),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Step Controls
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isPlaying ? null : _playSimulation,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play"),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isPlaying ? _pauseSimulation : null,
                          icon: const Icon(Icons.pause),
                          label: const Text("Pause"),
                        ),
                        ElevatedButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.skip_next),
                          label: const Text("Next Step"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Gantt Chart Section (wrap with horizontal scroll)
                const Text(
                  "Gantt Chart",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GanttChart(
                        processes: validProcesses,
                        highlightStep: _currentStep,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Summary Table Section
                const Text(
                  "Summary Table",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SummaryTable(processes: validProcesses),
                  ),
                ),
                const SizedBox(height: 30),

                // Bar Graph Section
                const Text(
                  "Bar Graph",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: BarGraph(processes: validProcesses),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
