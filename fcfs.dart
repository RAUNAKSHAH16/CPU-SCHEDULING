import '../models/process.dart';

class FCFS {
  static void schedule(List<Process> processes) {
    // Sort by arrival time
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

    int currentTime = 0;

    for (var process in processes) {
      if (currentTime < process.arrivalTime) {
        currentTime = process.arrivalTime;
      }

      process.startTime = currentTime;
      process.completionTime = currentTime + process.burstTime;
      process.turnaroundTime = process.completionTime! - process.arrivalTime;
      process.waitingTime = process.turnaroundTime! - process.burstTime;

      currentTime = process.completionTime!;
    }
  }
}
