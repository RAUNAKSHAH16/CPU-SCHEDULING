import '../models/process.dart';

class RoundRobin {
  static void schedule(List<Process> processes, int quantum) {
    int time = 0;
    List<int> remainingBT = processes.map((p) => p.burstTime).toList();
    List<int?> startTime = List.filled(processes.length, null);
    List<Process> queue = [];

    int completed = 0;
    int index = 0;

    while (completed < processes.length) {
      // Add processes that have arrived
      for (int i = 0; i < processes.length; i++) {
        if (processes[i].arrivalTime <= time &&
            !queue.contains(processes[i]) &&
            remainingBT[i] > 0 &&
            (startTime[i] == null || processes[i].completionTime == null)) {
          queue.add(processes[i]);
        }
      }

      if (queue.isEmpty) {
        time++;
        continue;
      }

      Process current = queue.removeAt(0);
      index = processes.indexOf(current);

      if (startTime[index] == null) {
        startTime[index] = time;
        processes[index].startTime = time;
      }

      int execTime = remainingBT[index] > quantum ? quantum : remainingBT[index];
      time += execTime;
      remainingBT[index] -= execTime;

      // Add newly arrived processes during execution
      for (int i = 0; i < processes.length; i++) {
        if (processes[i].arrivalTime <= time &&
            !queue.contains(processes[i]) &&
            remainingBT[i] > 0) {
          queue.add(processes[i]);
        }
      }

      if (remainingBT[index] > 0) {
        queue.add(current);
      } else {
        processes[index].completionTime = time;
        processes[index].turnaroundTime = time - processes[index].arrivalTime;
        processes[index].waitingTime =
            processes[index].turnaroundTime! - processes[index].burstTime;
        completed++;
      }
    }
  }
}
