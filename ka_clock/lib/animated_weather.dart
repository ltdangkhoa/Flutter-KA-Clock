import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

final _random = new math.Random();
int _rand(int min, int max) => min + _random.nextInt(max - min);

class AnimatedWeather extends StatefulWidget {
  AnimatedWeather({this.weather});
  final WeatherCondition weather;

  @override
  _AnimatedWeatherState createState() => _AnimatedWeatherState();
}

class _AnimatedWeatherState extends State<AnimatedWeather>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
//  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _standClouds = getStandCloud();
    _clouds = getCloudy(300);
    _rains = getRainy();
    _snows = getSnowy();
    _fogs = getFoggy();
    _flashes = getFlash();

    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _clouds = getCloudy(300);
        _rains = getRainy();
        _snows = getSnowy();
        _fogs = getFoggy();
        _flashes = getFlash();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

//    _animation = new Tween<double>(begin: 0.0, end: 1.0).animate(
//        new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _standClouds;
  Widget getStandCloud() {
    List<double> _tops = [10, 10, 0];
    List<double> _lefts = [70, 0, 0];
    List<double> _rights = [0, 80, 0];
    List<double> _sizes = [60, 50, 80];
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

  Widget _clouds;
  Widget getCloudy(_width) {
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

  Widget _rains;
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

  Widget _snows;
  Widget getSnowy() {
    List<Widget> _widgets = [];
    for (int i = 0; i < 5; i++) {
      _widgets.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, _rand(0, 60).toDouble(), 0, 0),
            child: Icon(
              Icons.ac_unit,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Flex(direction: Axis.horizontal, children: _widgets);
  }

  Widget _fogs;
  Widget getFoggy() {
    List<Widget> _widgets = [];
    for (int i = 0; i < 5; i++) {
      _widgets.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, _rand(0, 50).toDouble()),
            child: Icon(
              Icons.power_input,
              size: 30,
              color: Colors.white38,
            ),
          ),
        ),
      );
    }
    return Flex(direction: Axis.horizontal, children: _widgets);
  }

  Widget _flashes;
  Widget getFlash() {
    List<Widget> _widgets = [];
    for (int i = 0; i < 3; i++) {
      _widgets.add(
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, _rand(30, 70).toDouble(), 0, 0),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final _width = constraints.constrainWidth();
        final _height = constraints.constrainHeight();
        if (widget.weather == WeatherCondition.rainy) {
          return WeatherRainy(
            controller: _controller,
            width: _width,
            items: _rains,
            standCloud: _standClouds,
          );
        } else if (widget.weather == WeatherCondition.cloudy) {
          return WeatherCloudy(
            controller: _controller,
            width: _width,
            items: _clouds,
          );
        } else if (widget.weather == WeatherCondition.foggy) {
          return WeatherFoggy(
            controller: _controller,
            width: _width,
            items: _fogs,
            standCloud: _standClouds,
          );
        } else if (widget.weather == WeatherCondition.sunny) {
          return WeatherSunny(controller: _controller);
        } else if (widget.weather == WeatherCondition.snowy) {
          return WeatherSnowy(
            controller: _controller,
            width: _width,
            items: _snows,
            standCloud: _standClouds,
          );
        } else if (widget.weather == WeatherCondition.thunderstorm) {
          return WeatherThunderStorm(
            controller: _controller,
            width: _width,
            items: _flashes,
            standCloud: _standClouds,
          );
        } else if (widget.weather == WeatherCondition.windy) {
          return WeatherCloudy(
            controller: _controller,
            width: _width,
            items: _clouds,
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class WeatherSunny extends AnimatedWidget {
  const WeatherSunny({Key key, AnimationController controller})
      : super(key: key, listenable: controller);

  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 15,
            child: Transform.rotate(
              angle: _animation.value * 2.0 * math.pi,
              child: Icon(
                Icons.wb_sunny,
                size: 60,
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherCloudy extends AnimatedWidget {
  const WeatherCloudy(
      {Key key, AnimationController controller, this.width, this.items})
      : super(key: key, listenable: controller);
  final double width;
  final Widget items;
  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    double _cx0 = -width / 3;
    double _cx1 = width;
    double _cx = _animation.value * (_cx1 - _cx0) + _cx0;
    return Transform.translate(
      offset: Offset(_cx, 0),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              child: items,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherRainy extends AnimatedWidget {
  const WeatherRainy(
      {Key key,
      AnimationController controller,
      this.width,
      this.standCloud,
      this.items})
      : super(key: key, listenable: controller);
  final double width;
  final Widget items;
  final Widget standCloud;
  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    double _rx0 = 30;
    double _rx1 = -90;
    double _rx = (_animation.value * (_rx1 - _rx0) + _rx0);
    double _ry0 = 30;
    double _ry1 = 500;
    double _ry = (_animation.value * (_ry1 - _ry0) + _ry0) % 50 + _ry0;
    return Stack(
      children: <Widget>[
        Container(child: standCloud),
        Positioned(
          left: width / 3,
          right: width / 3,
          child: Transform.translate(
            offset: Offset(_rx, _ry),
            child: Container(
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherSnowy extends AnimatedWidget {
  const WeatherSnowy(
      {Key key,
      AnimationController controller,
      this.width,
      this.standCloud,
      this.items})
      : super(key: key, listenable: controller);
  final double width;
  final Widget items;
  final Widget standCloud;
  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    double _rx = 0;
    double _ry0 = 20;
    double _ry1 = 500;
    double _ry = (_animation.value * (_ry1 - _ry0) + _ry0) % 50 + _ry0;
    return Stack(
      children: <Widget>[
        Container(child: standCloud),
        Positioned(
          left: width / 3,
          right: width / 3,
          child: Transform.translate(
            offset: Offset(_rx, _ry),
            child: Container(
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherFoggy extends AnimatedWidget {
  const WeatherFoggy(
      {Key key,
      AnimationController controller,
      this.width,
      this.standCloud,
      this.items})
      : super(key: key, listenable: controller);
  final double width;
  final Widget items;
  final Widget standCloud;
  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    double _rx = 0;
    double _ry0 = 60;
    double _ry1 = 40;
    double _ry = (_animation.value * (_ry1 - _ry0) + _ry0);
    return Stack(
      children: <Widget>[
        Container(child: standCloud),
        Positioned(
          left: width / 3,
          right: width / 3,
          child: Transform.translate(
            offset: Offset(_rx, _ry),
            child: Container(
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}

class WeatherThunderStorm extends AnimatedWidget {
  const WeatherThunderStorm(
      {Key key,
      AnimationController controller,
      this.width,
      this.standCloud,
      this.items})
      : super(key: key, listenable: controller);
  final double width;
  final Widget items;
  final Widget standCloud;
  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    double _opacityLevel =
        (_animation.value * 100).toInt() % 5 == 0 ? 0.0 : 1.0;
    return Stack(
      children: <Widget>[
        Container(child: standCloud),
        Positioned(
          left: width / 3,
          right: width / 3,
          child: Container(
            child: AnimatedOpacity(
              opacity: _opacityLevel,
              duration: Duration(seconds: 1),
              child: items,
            ),
          ),
        ),
      ],
    );
  }
}
