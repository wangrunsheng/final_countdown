import 'dart:async';

import 'package:flutter/material.dart';

import 'package:final_countdown/data/file_stream_provider.dart';
import 'package:final_countdown/utils.dart';
import 'package:final_countdown/styling.dart';
import 'package:final_countdown/clocks/simple_clock.dart';
import 'package:final_countdown/data/countdown_provider.dart';
import 'package:fireworks/fireworks.dart';

class PhotoClock extends StatefulWidget {
  PhotoClock(this.countdownStream);
  final Stream<Duration> countdownStream;
  @override
  _PhotoClockState createState() => _PhotoClockState();
}

class _PhotoClockState extends State<PhotoClock> {
  StreamSubscription _countdownSubscription;
  bool _frontCamera;
  Camera _camera;

  @override
  void initState() {
    _frontCamera = true;
    _camera = Camera();
    _countdownSubscription = widget.countdownStream.listen((Duration d) {
      if (d.inSeconds % 60 == 0) _camera.takePicture();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CountdownProvider.of(context).stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget extra = Container();
        if (snapshot.connectionState == ConnectionState.done) {
          extra = Fireworks();
        }
        var cameraDisplay = Column(
          children: <Widget>[
            SimpleClock(style: artDecoStyle),
            Image.asset('assets/camera_top.png'),
            Filmstrip(),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset('assets/camera_bottom.png'),
                _cameraDirectionButton(),
              ],
            ),
          ],
        );

        return Stack(
          children: <Widget>[
            cameraDisplay,
            extra,
          ],
        );
      },
    );
  }

  _cameraDirectionButton() {
    return RaisedButton(
        color: Colors.white,
        child: Text(_frontCamera ? 'Use Back Camera' : 'Take Selfie',
            style: artDecoButtonStyle),
        onPressed: () {
          setState(() => _frontCamera = !_frontCamera);
          _camera.switchDirection();
        });
  }

  @override
  dispose() {
    _countdownSubscription.cancel();
    super.dispose();
  }
}

class Filmstrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FileStreamProvider.of(context).stream,
      builder: (BuildContext context, AsyncSnapshot photosList) {
        List<String> photoPaths = photosList.hasData ? photosList.data : [];
        return Expanded(
          child: Container(
            color: Colors.black,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: photoPaths.map((String s) => FilmImage(s)).toList(),
            ),
          ),
        );
      },
    );
  }
}
