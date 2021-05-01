import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues rangeValues;
  final Function(RangeValues values) onChanged;

  CustomRangeSlider(
      {Key key, this.min, this.max, this.rangeValues, this.onChanged})
      : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.min.toInt().toString()),
        Expanded(
          child: Center(
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  // activeTrackColor: Colors.red[700],
                  // inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  // thumbColor: Colors.redAccent,
                  // overlayColor: Colors.red.withAlpha(32),
                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  // activeTickMarkColor: Colors.red[700],
                  // inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  // valueIndicatorColor: Colors.redAccent,
                  // valueIndicatorTextStyle: TextStyle(
                  //   color: Colors.white,
                  // ),
                ),
                child: RangeSlider(
                    values: widget.rangeValues,
                    min: widget.min,
                    max: widget.max,
                    divisions: widget.max.toInt(),
                    labels: RangeLabels(
                      widget.rangeValues.start.round().toString(),
                      widget.rangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      widget.onChanged(values);
                    })),
          ),
        ),
        Text(widget.max.toInt().toString() + '+'),
      ],
    );
  }
}
