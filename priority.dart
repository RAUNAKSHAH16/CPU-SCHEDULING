import '../models/process.dart';
List<Map<String, dynamic>> priorityScheduling(List<Process> processes) {
  int time = 0;
  int completed = 0;
  int n = processes.length;

  List<Process> proc = processes.map((p) => Process(
    pid: p.pid,
    arrivalTime: p.arrivalTime,
    burstTime: p.burstTime,
    priority: p.priority,
  )).toList();

  List<bool> isCompleted = List.filled(n, false);
  List<Map<String, dynamic>> timeline = [];

  while (completed < n) {
    int idx = -1;
    int highestPriority = 9999;

    for (int i = 0; i < n; i++) {
      if (proc[i].arrivalTime <= time &&
          !isCompleted[i] &&
          (proc[i].priority ?? 9999) < highestPriority) {
        highestPriority = proc[i].priority ?? 9999;
        idx = i;
      }
    }

    if (idx == -1) {
      time++;
      continue;
    }

    int start = time;
    int end = time + proc[idx].burstTime;
    time = end;
    completed++;

    proc[idx].startTime = start;
    proc[idx].completionTime = end;
    proc[idx].turnaroundTime = end - proc[idx].arrivalTime;
    proc[idx].waitingTime = proc[idx].turnaroundTime! - proc[idx].burstTime;
    isCompleted[idx] = true;

    timeline.add({
      'processId': proc[idx].pid,
      'start': start,
      'end': end,
    });
  }

  for (int i = 0; i < n; i++) {
    processes[i].completionTime = proc[i].completionTime;
    processes[i].turnaroundTime = proc[i].turnaroundTime;
    processes[i].waitingTime = proc[i].waitingTime;
    processes[i].startTime = proc[i].startTime;
  }

  return timeline;
}
class PriorityScheduling {
  static void schedule(List<Process> processes) {
    priorityScheduling(processes);
  }
}
