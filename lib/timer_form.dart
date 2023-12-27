import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerForm extends StatefulWidget {
  final Function(int, DateTime, DateTime) onSubmit; // Modify this line

  TimerForm({required this.onSubmit});

  @override
  _TimerFormState createState() => _TimerFormState();
}

class _TimerFormState extends State<TimerForm> {
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final _minutesController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Define _selectedDate

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
              // Display selected date
              Text('Selected Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}'),
              const SizedBox(height: 15.0),
              // Date picker
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
          
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 15.0),
              // Display selected start time
              Text('Selected Start Time: ${_selectedStartTime.format(context)}'),
              const SizedBox(height: 15.0),
              // Start time picker
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _selectedStartTime,
                  );
          
                  if (pickedTime != null && pickedTime != _selectedStartTime) {
                    setState(() {
                      _selectedStartTime = pickedTime;
                    });
                  }
                },
                child: const Text('Select Start Time'),
              ),
              const SizedBox(height: 15.0),
              // Display selected end time
              Text('Selected End Time: ${_selectedEndTime.format(context)}'),
              const SizedBox(height: 15.0),
              // End time picker
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _selectedEndTime,
                  );
          
                  if (pickedTime != null && pickedTime != _selectedEndTime) {
                    setState(() {
                      _selectedEndTime = pickedTime;
                    });
                  }
                },
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