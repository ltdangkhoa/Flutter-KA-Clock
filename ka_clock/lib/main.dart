import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:ka_clock/animated_back.dart';
import 'package:ka_clock/animated_weather.dart';
import 'package:ka_clock/draw_around.dart';
import 'package:ka_clock/flip_digit.dart';

void main() {
  runApp(ClockCustomizer((ClockModel model) => KAClock(model)));
}

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class KAClock extends StatefulWidget {
  const KAClock(this.model);

  final ClockModel model;

  @override
  _KAClockState createState() => _KAClockState();
}

class _KAClockState extends State<KAClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _weather = WeatherCondition.sunny;
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';

  var selected = true;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(KAClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();

    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _weather = widget.model.weatherCondition;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final apm = DateFormat('aaa').format(_dateTime);
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
//      fontFamily: 'Poppins-Regular',
    );

    final backgroundLayer = Theme.of(context).brightness == Brightness.light
        ? Positioned.fill(child: AnimatedBack())
        : Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black,
                Colors.blueGrey.shade700,
              ],
            ),
          ));
    final weatherLayer = Theme.of(context).brightness == Brightness.light
        ? Positioned.fill(child: AnimatedWeather(weather: _weather))
        : Container();
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final _width = constraints.constrainWidth();
          final _height = constraints.constrainHeight();

          final digitSize = _width / 6.5;
          return Center(
            child: DefaultTextStyle(
              style: defaultStyle,
              child: Stack(
                children: <Widget>[
                  backgroundLayer,
                  weatherLayer,
                  Positioned(
                    bottom: 4.0,
                    left: 4.0,
                    right: 4.0,
                    top: 4.0,
                    child: CustomPaint(
                      painter: DrawAround(
                        int.parse(second),
                        Colors.white38,
                        6.0, //strokeWidth
                        0.0, //gap: space between each second
                      ),
                    ),
                  ),
                  Positioned(
                    child: Center(
                      child: Wrap(
                        children: <Widget>[
                          FlipDigit(hour[0], true, digitSize + 2),
                          FlipDigit(hour[1], true, digitSize + 2),
                          Container(
                            width: digitSize / 20,
                          ),
                          FlipDigit(minute[0], true, digitSize + 2),
                          FlipDigit(minute[1], true, digitSize + 2),
                          Container(
                            width: digitSize / 20,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: widget.model.is24HourFormat
                                    ? Container(
                                        width: digitSize,
                                        height: digitSize / 2 + 2,
                                      )
                                    : Wrap(
                                        children: <Widget>[
                                          FlipDigit(
                                              apm[0], false, digitSize / 2),
                                          FlipDigit(
                                              apm[1], false, digitSize / 2),
                                        ],
                                      ),
                              ),
                              Wrap(
                                children: <Widget>[
                                  FlipDigit(second[0], true, digitSize / 2),
                                  FlipDigit(second[1], true, digitSize / 2),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          _temperature,
                          style: TextStyle(
                            fontSize: digitSize / 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
