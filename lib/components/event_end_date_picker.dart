import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventEndDatePicker extends StatefulWidget {
  final TextEditingController eventEndDateController;
  final DateTime minDate;

  const EventEndDatePicker({
    Key? key,
    required this.eventEndDateController,
    required this.minDate,
  }) : super(key: key);

  @override
  State<EventEndDatePicker> createState() =>
      _EventEndDatePickerState();
}

class _EventEndDatePickerState extends State<EventEndDatePicker> {
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
      initialDate: _selectedDate.isAfter(widget.minDate)
          ? _selectedDate
          : widget.minDate,
      firstDate: widget.minDate,
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
