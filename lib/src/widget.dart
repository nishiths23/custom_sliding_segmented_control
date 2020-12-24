import 'package:custom_sliding_segmented_control/src/animation_panel.dart';
import 'package:custom_sliding_segmented_control/src/measure_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlidingSegmentedControl extends StatefulWidget {
  CustomSlidingSegmentedControl({
    Key key,
    @required this.onValueChanged,
    @required this.data,
    this.duration,
    this.radius = 4.0,
    this.elevation = 2.0,
    this.backgroundColor = CupertinoColors.systemGrey4,
    this.thumbColor = CupertinoColors.white,
    this.textColor = Colors.black,
    this.curve = Curves.easeInOut,
    this.innerPadding = 2.0,
    this.padding = 12,
    this.fixedWidth,
  }) : super(key: key);
  final ValueChanged<int> onValueChanged;
  final List<String> data;
  final Duration duration;
  final double radius;
  final double elevation;
  final Color backgroundColor;
  final Color thumbColor;
  final Color textColor;
  final Curve curve;
  final double innerPadding;
  final double padding;
  final double fixedWidth;

  @override
  _CustomSlidingSegmentedControlState createState() =>
      _CustomSlidingSegmentedControlState();
}

class _CustomSlidingSegmentedControlState
    extends State<CustomSlidingSegmentedControl> {
  String current;
  double offset = 0.0;
  double height;
  Map<int, double> sizes = {};

  @override
  void initState() {
    super.initState();
    current = widget.data[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(
              widget.radius != 0 ? widget.radius + 2 : widget.radius,
            ),
          ),
          padding: EdgeInsets.all(widget.innerPadding),
          child: Column(
            children: [
              Stack(
                children: [
                  AnimationPanel(
                    offset: offset,
                    height: height,
                    width: sizes[widget.data.indexOf(current)],
                    text: widget.data[widget.data.indexOf(current)],
                    duration: widget.duration,
                    radius: widget.radius,
                    elevation: widget.elevation,
                    color: widget.thumbColor,
                    curve: widget.curve,
                  ),
                  Row(
                    children: [
                      for (var item in widget.data)
                        MeasureSize(
                          onChange: (v) {
                            if (height == null) height = v.height;
                            final Map<int, double> _temp = {};
                            _temp.putIfAbsent(widget.data.indexOf(item),
                                () => widget.fixedWidth ?? v.width);
                            setState(() => sizes = {...sizes, ..._temp});
                          },
                          child: InkWell(
                            borderRadius: BorderRadius.circular(widget.radius),
                            onTap: () {
                              current = item;
                              final _offset = sizes.values
                                  .toList()
                                  .getRange(0, widget.data.indexOf(current))
                                  .toList();
                              if (_offset.isNotEmpty) {
                                final computeOffset = _offset.reduce(
                                    (value, element) => value + element);
                                setState(() => offset = computeOffset);
                              } else {
                                setState(() => offset = 0);
                              }
                              if (widget.onValueChanged != null)
                                widget.onValueChanged(
                                    widget.data.indexOf(current));
                            },
                            child: Container(
                              width: widget.fixedWidth ?? null,
                              padding: EdgeInsets.all(widget.padding),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.radius),
                              ),
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: widget.textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
