import '../models/process.dart';
class MLQ {
  static List<Process> schedule(List<Process> processes, {int timeQuantum = 2}) {
    List<Process> result = [];
    int currentTime = 0;

    // Separate into queues based on priority
    List<Process> queue1 = processes.where((p) => (p.priority ?? 0) <= 2).toList(); // High priority
    List<Process> queue2 = processes.where((p) => (p.priority ?? 0) > 2).toList();  // Low priority

    // --- Queue 1 (FCFS Scheduling) ---
    queue1.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    for (var p in queue1) {
      if (currentTime < p.arrivalTime) {
        currentTime = p.arrivalTime;
      }
      p.startTime = currentTime;
      p.completionTime = currentTime + p.burstTime;
      p.turnaroundTime = p.completionTime! - p.arrivalTime;
      p.waitingTime = p.turnaroundTime! - p.burstTime;
      currentTime += p.burstTime;
      result.add(p);
    }

    // --- Queue 2 (Round Robin Scheduling) ---
    List<Process> rrQueue = List.from(queue2);
    while (rrQueue.isNotEmpty) {
      Process p = rrQueue.removeAt(0);

      if (currentTime < p.arrivalTime) {
        currentTime = p.arrivalTime;
      }

      if (p.startTime == null) p.startTime = currentTime;

      if (p.burstTime <= timeQuantum) {
        currentTime += p.burstTime;
        p.completionTime = currentTime;
        p.turnaroundTime = p.completionTime! - p.arrivalTime;
        p.waitingTime = p.turnaroundTime! - p.burstTime;
        result.add(p);
      } else {
        currentTime += timeQuantum;
        rrQueue.add(Process(
          pid: p.pid,
          arrivalTime: currentTime,
          burstTime: p.burstTime - timeQuantum,
          priority: p.priority,
          startTime: p.startTime,
        ));
      }
    }

    return result;
  }
}
