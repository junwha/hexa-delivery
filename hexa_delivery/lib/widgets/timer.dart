import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final Color? textColor;
  const TimerWidget(this.duration, {this.textColor, this.callback, super.key});
  final Function()? callback;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();
  Timer? timer;

  void addTime() {
    const addSeconds = -1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        if (widget.callback != null) widget.callback!();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void reset() {
    setState(() => duration = widget.duration);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    reset();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration == Duration.zero) {
      return Text(
        '            ',
        // '${duration.inSeconds}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: widget.textColor ?? Colors.red,
        ),
      );
    }

    return Text(
      '$hours시 $minutes분 $seconds초',
      // '${duration.inSeconds}',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.red,
      ),
    );
  }
}
