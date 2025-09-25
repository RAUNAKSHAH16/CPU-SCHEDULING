class Process {
  final String pid;         // Process ID (e.g., P1, P2)
  final int arrivalTime;    // Arrival Time
  final int burstTime;      // Burst Time
  final int? priority;      // Optional: Priority (used in priority scheduling)

  // These fields are computed after scheduling
  int? startTime;           // Start Time
  int? completionTime;      // Completion Time
  int? turnaroundTime;      // Turnaround Time (TAT = CT - AT)
  int? waitingTime;         // Waiting Time (WT = TAT - BT)

  Process({
    required this.pid,
    required this.arrivalTime,
    required this.burstTime,
    this.priority,
    this.startTime,
    this.completionTime,
    this.turnaroundTime,
    this.waitingTime,
  });
}
