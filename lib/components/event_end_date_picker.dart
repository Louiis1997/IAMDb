import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventEndScrollDatePicker extends StatefulWidget {
  final TextEditingController eventEndDateController;

  const EventEndScrollDatePicker(
      {Key? key, required this.eventEndDateController})
      : super(key: key);

  @override
  State<EventEndScrollDatePicker> createState() =>
      _EventEndScrollDatePickerState();
}

class _EventEndScrollDatePickerState extends State<EventEndScrollDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.eventEndDateController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'End date',
        hintText: '2021-01-01',
        filled: false,
      ),
      onTap: _onTap,
      textInputAction: TextInputAction.next,
    );
  }

  void _onTap() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          widget.eventEndDateController.text =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
        });
      }
    });
  }
}
