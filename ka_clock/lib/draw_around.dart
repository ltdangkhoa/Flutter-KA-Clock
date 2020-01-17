import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class DrawAround extends CustomPainter {
  int _times = 0;
  Color _color = Colors.transparent;
  double _sW = 10.0;
  double _gap = 0.0;
  double _corner = 30.0;
  double _cornerS = 16.0;
  DrawAround(
    this._times,
    this._color,
    this._sW,
    this._gap,
  );

  @override
  void paint(Canvas canvas, Size size) {
    double _hW = size.width / 2;
    double _w = size.width;
    double _hH = size.height / 2;
    double _h = size.height;
    double _gapH = _gap * _h / _w;
    Paint paint;
    paint = new Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _sW;

    num degToRad(num deg) => deg * (math.pi / 180.0);

    Path path = Path();

    for (var i = 0; i < _times; i++) {
      if (i < 7) {
        int _f = i - 0;
        int _t = _f + 1;
        path.moveTo(_hW + _f * ((_hW - _cornerS) / 7), _sW / 2);
        path.lineTo(_hW + _t * ((_hW - _cornerS) / 7) - _gap, _sW / 2);
      } else if (i < 8) {
        path.arcTo(
            Rect.fromLTWH(_w - (_corner + _sW / 2), _sW / 2, _corner, _corner),
            degToRad(270),
            degToRad(90),
            true);
      } else if (i < 22) {
        int _f = i - 8;
        int _t = _f + 1;
        path.moveTo(
            _w - _sW / 2, _cornerS + _f * ((_hH - _cornerS) / 7) + _gapH);
        path.lineTo(
            _w - _sW / 2, _cornerS + _t * ((_hH - _cornerS) / 7) - _gapH);
      } else if (i < 23) {
        path.arcTo(
            Rect.fromLTWH(_w - (_corner + _sW / 2), _h - (_corner + _sW / 2),
                _corner, _corner),
            degToRad(0),
            degToRad(90),
            true);
      } else if (i < 37) {
        int _f = i - 23;
        int _t = _f + 1;
        path.moveTo(
            _w - _cornerS - _f * ((_hW - _cornerS) / 7) - _gap, _h - _sW / 2);
        path.lineTo(
            _w - _cornerS - _t * ((_hW - _cornerS) / 7) + _gap, _h - _sW / 2);
      } else if (i < 38) {
        path.arcTo(
            Rect.fromLTWH(_sW / 2, _h - (_corner + _sW / 2), _corner, _corner),
            degToRad(90),
            degToRad(90),
            true);
      } else if (i < 52) {
        int _f = i - 38;
        int _t = _f + 1;
        path.moveTo(
            _sW / 2, _h - _cornerS - _f * ((_hH - _cornerS) / 7) - _gapH);
        path.lineTo(
            _sW / 2, _h - _cornerS - _t * ((_hH - _cornerS) / 7) + _gapH);
      } else if (i < 53) {
        path.arcTo(Rect.fromLTWH(_sW / 2, _sW / 2, _corner, _corner),
            degToRad(180), degToRad(90), true);
      } else if (i < 60) {
        int _f = i - 53;
        int _t = _f + 1;
        path.moveTo(_cornerS + _f * ((_hW - _cornerS) / 7) + _gap, _sW / 2);
        path.lineTo(_cornerS + _t * ((_hW - _cornerS) / 7) - _gap, _sW / 2);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DrawAround oldDelegate) {
    return true;
  }
}
