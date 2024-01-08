import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'timer_form.dart';
import 'timer_model.dart';
import 'timer_manager.dart';

class TimerList extends StatefulWidget {
  final TimerManager timerManager;

  const TimerList({required this.timerManager});
  @override
  _TimerListState createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  final TimerManager _timerManager = TimerManager();
  final TextEditingController _minutesController = TextEditingController();
  final TimeOfDay _selectedStartTime = TimeOfDay.now();

  void _addTimer(int minutes, DateTime startTime, DateTime endTime) {
    _timerManager.addTimer(minutes, startTime, endTime);
  }

  void _deleteTimer(int index) {
    _timerManager.removeTimer(index);
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd-MM-yyyy HH:mm').format(time);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
      ),
      body: StreamBuilder<List<TimerModel>>(
        stream: _timerManager.timersStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No timers set.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final timer = snapshot.data![index];
              final startTime = _formatTime(timer.startTime);
              final endTime = _formatTime(timer.endTime);

              return Dismissible(
                key: Key(timer.hashCode.toString()), // unique key for Dismissible
                onDismissed: (direction) {
                  _deleteTimer(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Timer deleted')),
                  );
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text('${timer.minutes} minutes timer'),
                  subtitle: Text('Starts at: $startTime\nEnds at: $endTime'),
                  trailing: IconButton(
                    hoverColor: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTimer(index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => TimerForm(
            onSubmit: _addTimer,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
