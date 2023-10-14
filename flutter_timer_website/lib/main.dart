import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool timerStarted = false;
  late int _seconds;
  late String _buttonText = "Start";
  final int _initialSeconds = 10; // Initial countdown time in seconds
  late TextEditingController _textFieldController;
  String _textFieldValue = "";
  late AnimationController _animationController;
  bool _isAnimating = false;
  Widget _gifImage = Image.asset("assets/idle.gif"); // Initialize with idle.gif

  @override
  void initState() {
    super.initState();
    _seconds = _initialSeconds;
    _textFieldController = TextEditingController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Set the duration of the GIF animation
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _isAnimating = false;
      }
    });
  }

  void startTimer() {
    stopAnimation();
    if (_timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds == 0) {
          timer.cancel();
          changeImage("assets/animation_once.gif"); // Change the image
          startAnimation(); // Start the animation
          timerStarted = false;
          setState(() {
            _buttonText = "Start";
          });
          _seconds = _initialSeconds;
          _timer = null;
        } else {
          setState(() {
            _seconds--;
          });
        }
      });
      timerStarted = true;
      setState(() {
        _buttonText = "Pause";
      });
    } else {
      _timer!.cancel();
      _timer = null;
      setState(() {
        _buttonText = "Resume";
      });
    }
  }

  void startAnimation() {
    if (!_isAnimating) {
      _animationController.forward();
      _isAnimating = true;
    }
  }

  void stopAnimation() {
    if (_isAnimating) {
      _animationController.stop();
      _isAnimating = false;
    }
  }

  void changeImage(String val) {
    setState(() {
      _gifImage = Image.asset(val); // Change the image
    });
  }

  String formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  void saveTextFieldValue() {
    _textFieldValue = _textFieldController.text;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            height: kToolbarHeight,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
          backgroundColor: Colors.white,
        ),
        body: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 229, 229, 229), width: 2.0),
                      color: const Color.fromARGB(255, 196, 40, 40)//Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0), 
                      child:TextField(
                        controller: _textFieldController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 229, 229, 229)
                          ),
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 229, 229, 229), width: 2.0),
                            color: const Color.fromARGB(255, 196, 40, 40)//Colors.white,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(255, 229, 229, 229),
                                      ),
                            child: Container(
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return _gifImage;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 229, 229, 229), width: 2.0),
                            color: const Color.fromARGB(255, 196, 40, 40)//Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Time left: ${formatTime(_seconds ~/ 3600)}:${formatTime((_seconds % 3600) ~/ 60)}:${formatTime(_seconds % 60)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 229, 229, 229),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    saveTextFieldValue();
                                    startTimer();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 229, 229, 229)),
                                  ),
                                  child: Text(
                                    _buttonText,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextEditingController extends TextEditingController {
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }
}