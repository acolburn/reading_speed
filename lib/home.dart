//Stopwatch help from https://tinyurl.com/y6bkyf6u

import 'package:flutter/material.dart';
import 'dart:async';
import 'buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController _totalWordsController;
  TextEditingController _linesPerPageController;
  TextEditingController _pagesController;

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  Future<void> _populateFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _txtTotalWords = prefs.getString('totalWords') ?? '0';
      _txtLinesPerPage = prefs.getString('linesPerPage') ?? '0';
      _txtPages = prefs.getString('pages') ?? '1';
    });
    _totalWordsController = TextEditingController(text: _txtTotalWords);
    _linesPerPageController = TextEditingController(text: _txtLinesPerPage);
    _pagesController = TextEditingController(text: _txtPages);
  }

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset:
            false, //keyboard slides over UI without resizing UI
        appBar: AppBar(
          title: Text('FIND YOUR READING SPEED'),
        ),
        body: _buildBody(),
      ),
    );
  } //end build

  Widget _buildBody() {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.stretch,
    return ListView(
      children: <Widget>[
        buildStopwatch(),
        buildInputSection(),
        buildReadingSpeedDisplay(),
      ],
    );
  }

  Container buildReadingSpeedDisplay() {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          MyButton(
            buttonText: "Find Reading Speed!",
            onPress: _calculateReadingSpeed,
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Text(
              _readingSpeed.toString() + " wpm",
//              style: TextStyle(fontSize: 56),
              style: kNumberTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Container buildInputSection() {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: Column(
        children: <Widget>[
          TextField(
              controller: _totalWordsController,
              decoration: InputDecoration(
                labelText: "Total words for 5 lines",
              ),
//                labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
              keyboardType: TextInputType.number,
              onSubmitted: (String value) async {
                _txtTotalWords = value;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('totalWords', value);
              }),
          TextField(
            controller: _linesPerPageController,
            decoration: InputDecoration(
              labelText: "Lines per page",
            ),
//              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
            keyboardType: TextInputType.number,
            onSubmitted: (String value) async {
              _txtLinesPerPage = value;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('linesPerPage', value);
            },
          ),
          TextField(
            controller: _pagesController,
            decoration: InputDecoration(
              labelText: "No of pages read",
            ),
//              labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 3)),
            keyboardType: TextInputType.number,
            onSubmitted: (String value) async {
              _txtPages = value;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('pages', value);
            },
          ),
        ],
      ),
    );
  }

  Container buildStopwatch() {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MyButton(
                  buttonText: _buttonText, onPress: _startStopButtonPressed),
              MyButton(buttonText: "Reset", onPress: _resetButtonPressed),
            ],
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Text(
              _stopwatchText,
//              style: TextStyle(fontSize: 56),
              style: kNumberTextStyle,
            ),
          ),
        ], //Row children
      ),
    );
  } //end buildStopwatch

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
