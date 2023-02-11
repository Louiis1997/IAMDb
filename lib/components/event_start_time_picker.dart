import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/validator.dart';

class EventStartScrollTimePicker extends StatefulWidget {
  final TextEditingController eventStartTimeController;

  const EventStartScrollTimePicker({Key? key, required this.eventStartTimeController})
      : super(key: key);

  @override
  State<EventStartScrollTimePicker> createState() =>
      _EventStartScrollTimePickerState();
}

class _EventStartScrollTimePickerState extends State<EventStartScrollTimePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.eventStartTimeController,
      validator: (value) => Validator.validateForm(value ?? ""),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Start time',
        hintText: '00:00:00',
        filled: false,
      ),
      onTap: _onTap,
      textInputAction: TextInputAction.next,
    );
  }

  void _onTap() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            value.hour,
            value.minute,
          );
          widget.eventStartTimeController.text =
              DateFormat('HH:mm:ss').format(_selectedDate);
        });
      }
    });
  }
}
