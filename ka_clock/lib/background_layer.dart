import 'package:flutter/material.dart';

class BackgroundLayer extends StatelessWidget {
  final Brightness brightness;
  final String second;
  final double width;
  final double height;
  const BackgroundLayer({this.second, this.height, this.width, this.brightness});

  Alignment _beginAlignment(_quarter, _value) {
    Alignment _alignment;
    if (_quarter == 0) {
      _alignment = Alignment(_value, -1.0);
    } else if (_quarter == 1) {
      _alignment = Alignment(1.0, _value);
    } else if (_quarter == 2) {
      _alignment = Alignment(-_value, 1.0);
    } else if (_quarter == 3) {
      _alignment = Alignment(-1.0, -_value);
    }
    return _alignment;
  }

  Alignment _endAlignment(_quarter, _value) {
    Alignment _alignment;
    if (_quarter == 0) {
      _alignment = Alignment(-_value, 1.0);
    } else if (_quarter == 1) {
      _alignment = Alignment(-1.0, -_value);
    } else if (_quarter == 2) {
      _alignment = Alignment(_value, -1.0);
    } else if (_quarter == 3) {
      _alignment = Alignment(1.0, _value);
    }
    return _alignment;
  }

  @override
  Widget build(BuildContext context) {
    final double _endTween = double.parse(second) % 15 == 0 ? 1.0 : 0;
    final int _quarter = int.parse(second) ~/ 15;
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: _endTween),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _beginAlignment(_quarter, value),
              end: _endAlignment(_quarter, value),
              colors: [
                brightness == Brightness.light? Colors.blue: Colors.blueGrey.shade700,
                brightness == Brightness.light? Colors.red: Colors.black,
              ],
            ),
          ),
        );
      },
    );
  }
}
