import '../models/process.dart';

class SRTF {
  static void schedule(List<Process> processes) {
    int n = processes.length;
    int time = 0;
    int completed = 0;

    // Deep copy to track remaining times
    List<Process> proc = processes
        .map((p) => Process(
      pid: p.pid,
      arrivalTime: p.arrivalTime,
      burstTime: p.burstTime,
      priority: p.priority,
    ))
        .toList();

    List<int> remainingTime = proc.map((p) => p.burstTime).toList();
    List<bool> isCompleted = List.filled(n, false);

    while (completed < n) {
      int minIndex = -1;
      int minTime = 1 << 30;

      // Find the process with the shortest remaining time
      for (int i = 0; i < n; i++) {
        if (proc[i].arrivalTime <= time &&
            !isCompleted[i] &&
            remainingTime[i] < minTime &&
            remainingTime[i] > 0) {
          minTime = remainingTime[i];
          minIndex = i;
        }
      }

      if (minIndex == -1) {
        // No process available, increment time
        time++;
        continue;
      }

      // If first execution, set startTime
      if (proc[minIndex].startTime == null) {
        proc[minIndex].startTime = time;
      }

      remainingTime[minIndex]--;
      time++;

      // Process finished
      if (remainingTime[minIndex] == 0) {
        isCompleted[minIndex] = true;
        completed++;

        proc[minIndex].completionTime = time;
        proc[minIndex].turnaroundTime =
            proc[minIndex].completionTime! - proc[minIndex].arrivalTime;
        proc[minIndex].waitingTime =
            proc[minIndex].turnaroundTime! - proc[minIndex].burstTime;
      }
    }

    // Update original processes with calculated values
    for (int i = 0; i < n; i++) {
      processes[i].startTime = proc[i].startTime;
      processes[i].completionTime = proc[i].completionTime;
      processes[i].turnaroundTime = proc[i].turnaroundTime;
      processes[i].waitingTime = proc[i].waitingTime;
    }
  }
}
