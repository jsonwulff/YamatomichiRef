import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String label;
  final bool boolean;
  final void Function(bool changed) onChanged;

  CustomCheckBox({
    Key key,
    this.label,
    this.boolean,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: boolean == true ? Colors.blue : Colors.black,
                  width: 2.3),
            ),
            width: 20,
            height: 20,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: boolean,
                key: key,
                onChanged: (changed) => onChanged(changed),
                checkColor: Colors.blue,
                activeColor: Colors.transparent,
              ),
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: label, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ],
    );
  }
}
