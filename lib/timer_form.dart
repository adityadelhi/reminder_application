import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerForm extends StatefulWidget {
  final Function(int, DateTime, DateTime) onSubmit;

  TimerForm({required this.onSubmit});

  @override
  _TimerFormState createState() => _TimerFormState();
}

class _TimerFormState extends State<TimerForm> {
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final _minutesController = TextEditingController();
  final _dateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  void _submit() {
    if (_formKey.currentState!.validate()) {
      DateTime startTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedStartTime.hour,
        _selectedStartTime.minute,
      );
      DateTime endTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedEndTime.hour,
        _selectedEndTime.minute,
      );

      widget.onSubmit(int.parse(_minutesController.text), startTime, endTime);
      Navigator.of(context).pop();
    }
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
      });
    }
  }

  void _selectTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _selectedStartTime : _selectedEndTime,
    );

    if (pickedTime != null && (isStartTime ? pickedTime != _selectedStartTime : pickedTime != _selectedEndTime)) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _minutesController,
                decoration: const InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: _dateController,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: _selectDate,
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () => _selectTime(true),
                child: const Text('Select Start Time'),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () => _selectTime(false),
                child: const Text('Select End Time'),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
