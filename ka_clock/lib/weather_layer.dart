import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

final _random = new math.Random();
int _rand(int min, int max) => min + _random.nextInt(max - min);

class WeatherLayer extends StatefulWidget {
  final WeatherCondition weather;
  final String second;
  final double width;
  final double height;

  const WeatherLayer({this.weather, this.second, this.width, this.height});

  @override
  _WeatherLayerState createState() => _WeatherLayerState();
}

class _WeatherLayerState extends State<WeatherLayer> {
  Widget _standClouds;
  Widget _items;

  void getItems() {
    if (widget.weather == WeatherCondition.windy) {
      _items = getCloudy();
    } else if (widget.weather == WeatherCondition.thunderstorm) {
      _items = getFlash();
    } else if (widget.weather == WeatherCondition.snowy) {
      _items = getSnowy();
    } else if (widget.weather == WeatherCondition.rainy) {
      _items = getRainy();
    } else if (widget.weather == WeatherCondition.foggy) {
      _items = getFoggy();
    }
  }

  @override
  void initState() {
    super.initState();
    _standClouds = getStandCloud(widget.height);
    getItems();
  }

  @override
  void didUpdateWidget(WeatherLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weather != oldWidget.weather) {
      getItems();
    }
    if (widget.height != oldWidget.height) {
      _standClouds = getStandCloud(widget.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.weather == WeatherCondition.sunny) {
      return WeatherSunny(
        second: widget.second,
        width: widget.width,
        height: widget.height,
      );
    } else if (widget.weather == WeatherCondition.cloudy) {
      return _standClouds;
    } else if (widget.weather == WeatherCondition.windy) {
      if (double.parse(widget.second) % 15 == 0) {
        getItems();
      }
      return WeatherWindy(
        second: widget.second,
        items: _items,
        width: widget.width,
        height: widget.height,
      );
    } else if (widget.weather == WeatherCondition.snowy) {
      if (double.parse(widget.second) % 15 == 0) {
        getItems();
      }
      return WeatherSnowy(
        second: widget.second,
        items: _items,
        width: widget.width,
        height: widget.height,
        standCloud: _standClouds,
      );
    } else if (widget.weather == WeatherCondition.rainy) {
      if (double.parse(widget.second) % 15 == 0) {
        getItems();
      }
      return WeatherRainy(
        second: widget.second,
        items: _items,
        width: widget.width,
        height: widget.height,
        standCloud: _standClouds,
      );
    } else if (widget.weather == WeatherCondition.foggy) {
      if (double.parse(widget.second) % 15 == 0) {
        getItems();
      }
      return WeatherFoggy(
        second: widget.second,
        items: _items,
        width: widget.width,
        height: widget.height,
        standCloud: _standClouds,
      );
    } else if (widget.weather == WeatherCondition.thunderstorm) {
      if (double.parse(widget.second) % 3 == 0) {
        getItems();
      }
      return WeatherThunderStorm(
        second: widget.second,
        items: _items,
        width: widget.width,
        height: widget.height,
        standCloud: _standClouds,
      );
    } else {
      return Container();
    }
  }
}

class WeatherSunny extends StatelessWidget {
  const WeatherSunny({
    Key key,
    this.second,
    this.width,
    this.height,
  });
  final double width;
  final double height;
  final String second;

  @override
  Widget build(BuildContext context) {
    double _end = double.parse(second) % 15 == 0 ? 1.0 : 0.0;
    return Stack(
      children: <Widget>[
        Positioned(
          top: height / 15,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 500),
            tween: Tween(begin: 0.0, end: _end),
            child: Icon(
              Icons.wb_sunny,
              size: 60,
              color: Colors.white54,
            ),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 0.25 * math.pi,
                child: child,
              );
            },
          ),
        )
      ],
    );
  }
}

class WeatherWindy extends StatelessWidget {
  const WeatherWindy({
    Key key,
    this.second,
    this.width,
    this.height,
    this.items,
  });
  final double width;
  final double height;
  final String second;
  final Widget items;

  @override
  Widget build(BuildContext context) {
    final double _cx0 = -200;
    final double _cx1 = width;
    double _cx = (_cx1 - _cx0) * (double.parse(second) / 60) + _cx0;
    return Container(
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            left: _cx,
            duration: Duration(
              milliseconds: (double.parse(second) > 0 ? _rand(400, 900) : 1),
            ),
            curve: Curves.linear,
            child: Container(
              child: items,
              width: width,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherThunderStorm extends StatelessWidget {
  const WeatherThunderStorm(
      {Key key,
      this.second,
      this.width,
      this.height,
      this.items,
      this.standCloud});
  final double width;
  final double height;
  final String second;
  final Widget items;
  final Widget standCloud;

  @override
  Widget build(BuildContext context) {
    double _opacityLevel = double.parse(second) % 3 == 0 ? 1.0 : 0.0;
    return Stack(
      children: <Widget>[
        Container(child: standCloud),
        Positioned(
          left: width / 3,
          right: width / 3,
          child: Container(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _opacityLevel,
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherSnowy extends StatelessWidget {
  const WeatherSnowy(
      {Key key,
      this.second,
      this.width,
      this.height,
      this.items,
      this.standCloud});
  final double width;
  final double height;
  final String second;
  final Widget items;
  final Widget standCloud;

  @override
  Widget build(BuildContext context) {
    final double _cx0 = 0;
    final double _cx1 = height / 3;
    double _cx =
        ((_cx1 - _cx0) * (double.parse(second) / 15) + _cx0) % _cx1 - _cx1;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(child: standCloud),
          AnimatedPositioned(
            top: _cx,
            left: _rand(-5, 5).toDouble() + width / 4,
            duration: Duration(
              milliseconds: (double.parse(second) > 0 ? _rand(300, 700) : 1),
            ),
            curve: Curves.linear,
            child: Container(
              child: items,
              width: width / 2,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherRainy extends StatelessWidget {
  const WeatherRainy(
      {Key key,
      this.second,
      this.width,
      this.height,
      this.items,
      this.standCloud});
  final double width;
  final double height;
  final String second;
  final Widget items;
  final Widget standCloud;

  @override
  Widget build(BuildContext context) {
    final double _cx0 = 0;
    final double _cx1 = height / 4;
    double _cx =
        ((_cx1 - _cx0) * (double.parse(second) / 15) + _cx0) % _cx1 - _cx1;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(child: standCloud),
          AnimatedPositioned(
            top: _cx,
            left: width / 4 - _cx / 3,
            duration: Duration(
              milliseconds: (double.parse(second) > 0 ? _rand(300, 700) : 1),
            ),
            curve: Curves.linear,
            child: Container(
              child: items,
              width: width / 3,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherFoggy extends StatelessWidget {
  const WeatherFoggy(
      {Key key,
      this.second,
      this.width,
      this.height,
      this.items,
      this.standCloud});
  final double width;
  final double height;
  final String second;
  final Widget items;
  final Widget standCloud;

  @override
  Widget build(BuildContext context) {
    final double _cx0 = height / 6;
    final double _cx1 = height / 10;
    double _cx =
        ((_cx1 - _cx0) * (double.parse(second) / 15) + _cx0) % _cx1 - _cx0;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(child: standCloud),
          AnimatedPositioned(
            top: _cx,
            left: width / 3,
            right: width / 3,
            duration: Duration(
              milliseconds: (double.parse(second) > 0 ? 100 : 1),
            ),
            curve: Curves.linear,
            child: Container(
              child: items,
              width: width / 3,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}

Widget getCloudy() {
  List<Widget> _widgets = [];
  for (int i = 0; i < 5; i++) {
    _widgets.add(
      Positioned(
        top: _rand(0, 30).toDouble(),
        left: (i * 40).toDouble(),
        child: Icon(
          Icons.wb_cloudy,
          size: _rand(40, 80).toDouble(),
          color: Colors.white38,
        ),
      ),
    );
  }
  return Stack(children: _widgets);
}

Widget getFlash() {
  List<Widget> _widgets = [];
  for (int i = 0; i < 3; i++) {
    _widgets.add(
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, _rand(30, 60).toDouble(), 0, 0),
          child: Icon(
            Icons.flash_on,
            size: 45,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
  return Flex(direction: Axis.horizontal, children: _widgets);
}

Widget getSnowy() {
  List<Widget> _widgets = [];
  for (int i = 0; i < 5; i++) {
    _widgets.add(
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              _rand(0, 30).toDouble(), _rand(0, 60).toDouble(), 0, 0),
          child: Icon(
            Icons.ac_unit,
            size: 18,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
  return Flex(direction: Axis.horizontal, children: _widgets);
}

Widget getRainy() {
  List<Widget> _widgets = [];
  for (int i = 0; i < 5; i++) {
    _widgets.add(
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, _rand(0, 30).toDouble(), 0, 0),
          child: Transform.rotate(
            angle: 35,
            child: Icon(
              Icons.more_vert,
              size: 30,
              color: Colors.white38,
            ),
          ),
        ),
      ),
    );
  }
  return Flex(direction: Axis.horizontal, children: _widgets);
}

Widget getFoggy() {
  List<Widget> _widgets = [];
  for (int i = 0; i < 10; i++) {
    _widgets.add(
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, _rand(30, 60).toDouble()),
          child: Icon(
            Icons.scatter_plot,
            size: 13,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
  return Flex(direction: Axis.horizontal, children: _widgets);
}

Widget getStandCloud(height) {
  List<double> _tops = [10, 10, 0];
  List<double> _lefts = [70, 0, 0];
  List<double> _rights = [0, 80, 0];
  List<double> _sizes = [height / 6 + 10, height / 6, height / 6 + 30];
  List<Widget> _widgets = [];
  for (int i = 0; i < 3; i++) {
    _widgets.add(
      Positioned(
        top: _tops[i],
        left: _lefts[i],
        right: _rights[i],
        child: Icon(
          Icons.wb_cloudy,
          size: _sizes[i],
          color: Colors.white24,
        ),
      ),
    );
  }
  return Stack(children: _widgets);
}
