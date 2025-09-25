import '../models/process.dart';
class HRRN {
  static List<Process> schedule(List<Process> processes) {
    List<Process> result = [];
    List<Process> readyQueue = [];
    int currentTime = 0;
    List<Process> remaining = List.from(processes);

    while (remaining.isNotEmpty || readyQueue.isNotEmpty) {
      // Add processes that have arrived to readyQueue
      remaining
          .where((p) => p.arrivalTime <= currentTime)
          .toList()
          .forEach((p) {
        readyQueue.add(p);
      });
      remaining.removeWhere((p) => p.arrivalTime <= currentTime);

      if (readyQueue.isEmpty) {
        currentTime++;
        continue;
      }

      // Calculate response ratio = (WT + BT) / BT
      readyQueue.sort((a, b) {
        double responseA =
            ((currentTime - a.arrivalTime) + a.burstTime) / a.burstTime;
        double responseB =
            ((currentTime - b.arrivalTime) + b.burstTime) / b.burstTime;
        return responseB.compareTo(responseA);
      });

      Process current = readyQueue.removeAt(0);

      current.startTime = currentTime;
      current.completionTime = currentTime + current.burstTime;
      current.turnaroundTime = current.completionTime! - current.arrivalTime;
      current.waitingTime = current.turnaroundTime! - current.burstTime;

      currentTime += current.burstTime;
      result.add(current);
    }

    return result;
  }
}
