//Stopwatch help from https://tinyurl.com/y6bkyf6u

import 'package:flutter/material.dart';
import 'dart:async';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String _buttonText = "Start";
  String _stopwatchText = "00:00:00";
//  String _stopwatchInSecondsText = "0";
  int _readingSpeed = 0;
  String _txtTotalWords = "0";
  String _txtLinesPerPage = "0";
  String _txtPages = "1";
  final _stopWatch = Stopwatch();
  final _timeout = const Duration(seconds: 1);

  void _startTimeout() {
    Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Reading Speed'),
      ),
      body: _buildBody(),
    );
  } //end build

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
//              height: 180,
//              minWidth: 100,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                splashColor: Theme.of(context).accentColor,
                onPressed: _startStopButtonPressed,
                child: Text(_buttonText),
              ),
              MaterialButton(
//              height: 180,
//              minWidth: 100,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                splashColor: Theme.of(context).accentColor,
                onPressed: _resetButtonPressed,
                child: Text("Reset"),
              ),
            ],
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              _stopwatchText,
              style: TextStyle(fontSize: 56),
            ),
          ),
        ),
        Expanded(
          child: TextField(
              decoration: InputDecoration(
                labelText: "Enter total words for 5 lines",
              ),
//                labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
              keyboardType: TextInputType.number,
              onSubmitted: (String value) {
                _txtTotalWords = value;
              }),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Enter lines per page",
            ),
//              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
            keyboardType: TextInputType.number,
            onSubmitted: (String value) {
              _txtLinesPerPage = value;
            },
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Enter number of pages read",
            ),
//              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
            keyboardType: TextInputType.number,
            onSubmitted: (String value) {
              _txtPages = value;
            },
          ),
        ),
        Expanded(
          child: MaterialButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            splashColor: Theme.of(context).accentColor,
            onPressed: _calculateReadingSpeed,
            child: Text("Find Reading Speed!"),
          ),
        ),
        Expanded(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              _readingSpeed.toString() + " wpm",
              style: TextStyle(fontSize: 56),
            ),
          ),
        ),
      ],
    );
  } //end _buildBody

  void _startStopButtonPressed() {
    setState(() {
      //if stopWatch running, stop it, change button 'Start'
      if (_stopWatch.isRunning) {
        _buttonText = "Start";
        _stopWatch.stop();
      } else {
        //if stopWatch stopped, start it, change button 'Stop'
        _buttonText = "Stop";
        _stopWatch.start();
        _startTimeout();
      }
    });
  } //end _startStopButtonPressed

  void _resetButtonPressed() {
    if (_stopWatch.isRunning) {
      _startStopButtonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
      _readingSpeed = 0;
    });
  } //end _resetButtonPressed

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
//    _stopwatchInSecondsText =
//        _stopWatch.elapsed.inSeconds.toString() + " seconds";
  } //end _setStopwatchText

  void _calculateReadingSpeed() {
    setState(
      () {
        double _wordsinFiveLines = double.parse(_txtTotalWords);
        double _linesPerPage = double.parse(_txtLinesPerPage);
        int _pages = int.parse(_txtPages);
        double _words = (_wordsinFiveLines / 5) * _linesPerPage * _pages;
        double _minutes = _stopWatch.elapsed.inSeconds / 60;
        //error checking:
        if (_minutes == 0) {
          _minutes = _words;
        } //if timer hasn't started, make reading speed 1 wpm
        _readingSpeed =
            (_words / _minutes).round(); //.round() rounds to nearest int
      },
    );
  } //end _calculateReadingSpeed

} //end _HomeWidgetState
