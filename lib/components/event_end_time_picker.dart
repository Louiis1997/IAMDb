import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventEndScrollTimePicker extends StatefulWidget {
  final TextEditingController eventEndTimeController;

  const EventEndScrollTimePicker(
      {Key? key, required this.eventEndTimeController})
      : super(key: key);

  @override
  State<EventEndScrollTimePicker> createState() =>
      _EventEndScrollTimePickerState();
}

class _EventEndScrollTimePickerState extends State<EventEndScrollTimePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.eventEndTimeController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'End time',
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
          widget.eventEndTimeController.text =
              DateFormat('HH:mm:ss').format(_selectedDate);
        });
      }
    });
  }
}
