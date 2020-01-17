import 'package:flutter/material.dart';

class FlipDigit extends StatelessWidget {
  final String displayText;
  final bool isNumeric;
  final double size;
  const FlipDigit(this.displayText, this.isNumeric, this.size);

  Widget get _digits {
    List<Widget> _w = [];
    for (var i = 0; i < 10; i++) {
      _w.add(
        Container(
          height: size,
          width: size,
          child: Center(
            child: Text(
              i.toString(),
              style: TextStyle(
                fontSize: size * 2 / 3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: _w,
    );
  }

  Widget get _texts {
    return Column(
      children: [
        Container(
          height: size,
          width: size,
          child: Center(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: size * 2 / 3,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 2,
      height: size + 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white12,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                top: isNumeric ? -size * double.parse(displayText) : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
                child: isNumeric ? _digits : _texts,
              )
            ],
          ),
        ),
      ),
    );
  }
}
