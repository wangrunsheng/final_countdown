import 'package:flutter/material.dart';

import 'package:final_countdown/data/storage_provider.dart';
import 'package:final_countdown/data/countdown_stream.dart';

import 'package:final_countdown/clocks/simple_clock.dart';
import 'package:final_countdown/clocks/retro_clock.dart';
import 'package:final_countdown/clocks/photo_clock.dart';

void main() => runApp(CountdownApp());

class CountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s the final countdown!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: PhotoStorageProvider(
          child: CountdownProvider(
            duration: const Duration(minutes: 15),
            child: Center(
              child: PageView(
                children: <Widget>[
                  SimpleClock(),
                  RetroClock(),
                  PhotoClock(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
