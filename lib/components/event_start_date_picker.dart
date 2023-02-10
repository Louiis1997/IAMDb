import 'package:flutter/material.dart';
import 'package:iamdb/common/validator.dart';
import 'package:intl/intl.dart';

class EventStartScrollDatePicker extends StatefulWidget {
  final TextEditingController eventStartDateController;

  const EventStartScrollDatePicker(
      {Key? key, required this.eventStartDateController})
      : super(key: key);

  @override
  State<EventStartScrollDatePicker> createState() =>
      _EventStartScrollDatePickerState();
}

class _EventStartScrollDatePickerState
    extends State<EventStartScrollDatePicker> {
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
          widget.eventStartDateController.text =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
        });
      }
    });
  }
}
