//Deprecated and replaced by background_layer

import 'package:flutter/material.dart';

class AnimatedBack extends StatefulWidget {
  @override
  _AnimatedBackState createState() => _AnimatedBackState();
}

class _AnimatedBackState extends State<AnimatedBack>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int _quarter = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _quarter = _quarter == 3 ? 0 : _quarter + 1;
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _animation = new Tween<double>(begin: -1.0, end: 1.0).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Alignment _begin() {
    Alignment _alignment;
    if (_quarter == 0) {
      _alignment = Alignment(_animation.value, -1.0);
    } else if (_quarter == 1) {
      _alignment = Alignment(1.0, _animation.value);
    } else if (_quarter == 2) {
      _alignment = Alignment(-_animation.value, 1.0);
    } else if (_quarter == 3) {
      _alignment = Alignment(-1.0, -_animation.value);
    }
    return _alignment;
  }

  Alignment _end() {
    Alignment _alignment;
    if (_quarter == 0) {
      _alignment = Alignment(-_animation.value, 1.0);
    } else if (_quarter == 1) {
      _alignment = Alignment(-1.0, -_animation.value);
    } else if (_quarter == 2) {
      _alignment = Alignment(_animation.value, -1.0);
    } else if (_quarter == 3) {
      _alignment = Alignment(1.0, _animation.value);
    }
    return _alignment;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _begin(),
              end: _end(),
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
        );
      },
    );
  }
}
