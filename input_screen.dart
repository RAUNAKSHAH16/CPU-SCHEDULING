import 'package:flutter/material.dart';
import '../models/process.dart';
import '../widgets/process_card.dart';
import 'result_screen.dart';
import '../algorithms/fcfs.dart';
import '../algorithms/sjf.dart';
import '../algorithms/srtf.dart';
import '../algorithms/priority.dart';
import '../algorithms/round_robin.dart';

class InputScreen extends StatefulWidget {
  final String algorithm;

  const InputScreen({super.key, required this.algorithm});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final List<Process> processList = [];
  final TextEditingController pidController = TextEditingController();
  final TextEditingController atController = TextEditingController();
  final TextEditingController btController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController quantumController = TextEditingController();

  bool get isPriority => widget.algorithm == 'Priority';
  bool get isRR => widget.algorithm == 'Round Robin';

  void addProcess() {
    if (pidController.text.isEmpty ||
        atController.text.isEmpty ||
        btController.text.isEmpty) return;

    final newProcess = Process(
      pid: pidController.text,
      arrivalTime: int.parse(atController.text),
      burstTime: int.parse(btController.text),
      priority: isPriority && priorityController.text.isNotEmpty
          ? int.parse(priorityController.text)
          : null,
    );

    setState(() {
      processList.add(newProcess);
      pidController.clear();
      atController.clear();
      btController.clear();
      priorityController.clear();
    });
  }

  void proceed() {
    if (processList.isEmpty) return;

    final quantum = isRR ? int.tryParse(quantumController.text) ?? 2 : null;

    // Apply the chosen scheduling algorithm
    switch (widget.algorithm) {
      case 'FCFS':
        FCFS.schedule(processList);
        break;
      case 'SJF':
        SJF.schedule(processList);
        break;
      case 'SRTF':
        SRTF.schedule(processList);
        break;
      case 'Priority':
        PriorityScheduling.schedule(processList);
        break;
      case 'Round Robin':
        if (quantum != null) RoundRobin.schedule(processList, quantum);
        break;
      default:
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          processes: processList,
          algorithm: widget.algorithm,
          quantum: quantum,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.algorithm} - Input'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.purpleAccent.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Enter Process Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: pidController, decoration: const InputDecoration(labelText: 'Process ID')),
                    TextField(controller: atController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Arrival Time')),
                    TextField(controller: btController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Burst Time')),
                    if (isPriority)
                      TextField(controller: priorityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Priority')),
                    if (isRR)
                      TextField(controller: quantumController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Time Quantum')),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(onPressed: addProcess, icon: const Icon(Icons.add), label: const Text('Add Process')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Process List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // 🔥 change this color
              ),
            ),

            const SizedBox(height: 8),
            ...processList.map((process) => ProcessCard(
              process: process,
              onDelete: () {
                setState(() {
                  processList.remove(process);
                });
              },
              showPriority: isPriority,
            )),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: proceed, icon: const Icon(Icons.play_arrow), label: const Text('Run Scheduling')),
          ],
        ),
      ),
    );
  }
}
