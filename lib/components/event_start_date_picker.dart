import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/validators.dart';

class EventStartDatePicker extends StatefulWidget {
  final TextEditingController eventStartDateController;
  final Function(String) startDateOnChange;

  const EventStartDatePicker({
    Key? key,
    required this.eventStartDateController,
    required this.startDateOnChange,
  }) : super(key: key);

  @override
  State<EventStartDatePicker> createState() =>
      _EventStartDatePickerState();
}

class _EventStartDatePickerState
    extends State<EventStartDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.eventStartDateController,
      validator: (value) => Validator.validateForm(value ?? ""),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Start date',
        hintText: '2021-01-01',
        filled: false,
      ),
      onTap: _onTap,
      textInputAction: TextInputAction.next,
      onChanged: (value) => {
      },
    );
  }

  void _onTap() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          widget.eventStartDateController.text =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
          widget.startDateOnChange(value.toString());
        });
      }
    });
  }
}
