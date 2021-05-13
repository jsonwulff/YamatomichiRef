import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.controller,
    this.labelText,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.initialDatePickerMode = DatePickerMode.day,
    this.onPickedDate,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String Function(String value) validator;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DatePickerEntryMode initialEntryMode;
  final DatePickerMode initialDatePickerMode;
  final void Function(DateTime pickedDate) onPickedDate;

  void selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: initialEntryMode,
      initialDatePickerMode: initialDatePickerMode,
    );
    if (pickedDate != null) {
      onPickedDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: labelText,
          ),
          validator: (String value) => validator(value),
        ),
      ),
    );
  }
}
