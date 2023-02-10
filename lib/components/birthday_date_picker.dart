import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayScrollDatePicker extends StatefulWidget {
  final TextEditingController birthdayController;

  const BirthdayScrollDatePicker({Key? key, required this.birthdayController})
      : super(key: key);

  @override
  State<BirthdayScrollDatePicker> createState() =>
      _BirthdayScrollDatePickerState();
}

class _BirthdayScrollDatePickerState extends State<BirthdayScrollDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.birthdayController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Date of birth',
        hintText: '1984-01-01',
        filled: false,
      ),
      onTap: _onTap,
    );
  }

  void _onTap() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          widget.birthdayController.text =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
        });
      }
    });
  }
}
