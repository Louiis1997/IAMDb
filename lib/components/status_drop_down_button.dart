import 'package:flutter/material.dart';

const List<String> status = <String>[
  'Noob 🍚',
  'Néophyte 🍣',
  'Intermédiaire 🇯🇵',
  'Otaku 🎎',
  'Weeaboo 👺'
];

class StatusDropDownButton extends StatefulWidget {
  final void Function(String) onChanged;

  const StatusDropDownButton({super.key, required this.onChanged});

  @override
  State<StatusDropDownButton> createState() => _StatusDropDownButtonState();
}

class _StatusDropDownButtonState extends State<StatusDropDownButton> {
  String? _dropdownValue;
  String? _labelText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _dropdownValue,
      hint: const Text('Social status'),
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: (String? value) {
        setState(() {
          _dropdownValue = value!;
          widget.onChanged(_dropdownValue!);
          _labelText = 'Social status';
        });
      },
      items: status.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: _labelText,
      ),
    );
  }
}
