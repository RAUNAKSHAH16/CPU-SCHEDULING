import '../models/process.dart';

class SJF {
  static void schedule(List<Process> processes) {
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

    int n = processes.length;
    int currentTime = 0;
    List<bool> isDone = List.filled(n, false);
    int completed = 0;

    while (completed < n) {
      int idx = -1;
      int minBT = 1 << 30;

      for (int i = 0; i < n; i++) {
        if (!isDone[i] &&
            processes[i].arrivalTime <= currentTime &&
            processes[i].burstTime < minBT) {
          minBT = processes[i].burstTime;
          idx = i;
        }
      }

      if (idx != -1) {
        final p = processes[idx];
        p.startTime = currentTime;
        p.completionTime = currentTime + p.burstTime;
        p.turnaroundTime = p.completionTime! - p.arrivalTime;
        p.waitingTime = p.turnaroundTime! - p.burstTime;

        currentTime = p.completionTime!;
        isDone[idx] = true;
        completed++;
      } else {
        currentTime++;
      }
    }
  }
}
