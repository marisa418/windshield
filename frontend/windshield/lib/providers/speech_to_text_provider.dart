import 'package:flutter/material.dart';
import 'dart:math';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:windshield/models/daily_flow/flow_speech.dart';

class SpeechToTextProvider extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  SpeechToText get speech => _speech;

  bool _hasSpeech = false;
  bool get hasSpeech => _hasSpeech;

  double _level = 0.0;
  double get level => _level;

  double _minSoundLevel = 50000;
  double get minSoundLevel => _minSoundLevel;
  double _maxSoundLevel = -50000;
  double get maxSoundLevel => _maxSoundLevel;

  String _lastWords = '';
  String get lastWords => _lastWords;
  String _lastError = '';
  String get lastError => _lastError;
  String _lastStatus = '';
  String get lastStatus => _lastStatus;

  List<SpeechFlow> _flowList = [];
  List<SpeechFlow> get flowList => _flowList;
  String _dfId = '';
  String get dfId => _dfId;
  String _name = '';
  String get name => _name;
  double _value = 0;
  double get value => _value;
  String _catId = '';
  String get catId => _catId;
  int _method = 2;
  int get method => _method;

  int _flowIdx = 0;
  int get flowIdx => _flowIdx;

  int _key = 0;

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      // if (!mounted) return;
      _hasSpeech = hasSpeech;
      notifyListeners();
    } catch (e) {
      _lastError = 'Speech recognition failed: ${e.toString()}';
      _hasSpeech = false;
      notifyListeners();
    }
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _lastWords = '';
    _lastError = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: 'th_TH',
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
    notifyListeners();
  }

  void stopListening() {
    speech.stop();
    _level = 0.0;
    notifyListeners();
  }

  void cancelListening() {
    speech.cancel();
    _level = 0.0;
    notifyListeners();
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    if (result.finalResult) {
      print(result.recognizedWords);
      final numeratic = RegExp(r'^\d*\.?\d*$');
      final splittedWords = result.recognizedWords.split(' ');
      String name = '';
      int priceIdx = -1;
      String methodName = 'เงินสด';
      int method = 2;

      for (var i = splittedWords.length - 1; i > -1; i--) {
        if (numeratic.hasMatch(splittedWords[i])) {
          priceIdx = i;
          break;
        }
      }
      if (priceIdx == -1) {
        _lastWords = 'โปรดกรอกราคา';
        notifyListeners();
        return;
      } else if (priceIdx == 0) {
        _lastWords = 'โปรดกรอกชื่อรายการ';
        notifyListeners();
        return;
      }
      if (splittedWords.last.contains('โอน')) {
        methodName = 'โอน';
        method = 3;
      } else if (splittedWords.last.contains('บัตรเครดิต')) {
        methodName = 'บัตรเครดิต';
        method = 4;
      }
      for (var i = 0; i < priceIdx; i++) {
        if (splittedWords[i] == 'ราคา') {
          continue;
        }
        name = name + ' ${splittedWords[i]}';
      }
      name = name.replaceAll(RegExp(r'ราคา'), '');
      _flowList.add(SpeechFlow(
        dfId: _dfId,
        cat: SpeechCat(id: '', icon: '', color: Colors.white),
        name: name,
        value: double.parse(splittedWords[priceIdx]),
        method: method,
        key: _key.toString(),
      ));
      _key++;
      _lastWords = '$name ราคา ${splittedWords[priceIdx]} บาท ($methodName)';
      notifyListeners();
    }
  }

  void soundLevelListener(double level) {
    _minSoundLevel = min(minSoundLevel, level);
    _maxSoundLevel = max(maxSoundLevel, level);
    _level = level;
    notifyListeners();
  }

  void errorListener(SpeechRecognitionError error) {
    _lastError = '${error.errorMsg} - ${error.permanent}';
    notifyListeners();
  }

  void statusListener(String status) {
    _lastStatus = status;
    notifyListeners();
  }

  void setDfId(String value) {
    _dfId = value;
  }

  void setName(String value) {
    _name = value;
    _flowList[_flowIdx].name = value;
    notifyListeners();
  }

  void setValue(double value) {
    _value = value;
    _flowList[_flowIdx].value = value;
    notifyListeners();
  }

  void setCat(String id, String icon, Color color) {
    _flowList[_flowIdx].cat = SpeechCat(id: id, icon: icon, color: color);
    notifyListeners();
  }

  void setMethod(int value) {
    _method = value;
    _flowList[_flowIdx].method = value;
    notifyListeners();
  }

  void setFlowIdx(int value) {
    _flowIdx = value;
  }

  void removeFlow(int value) {
    _flowList.removeAt(value);
    notifyListeners();
  }

  void addFlowList() {
    _flowList.add(
      SpeechFlow(
        dfId: _dfId,
        cat: SpeechCat(id: '', icon: '', color: Colors.white),
        name: 'ข้าวมันไก่',
        value: 20,
        method: 2,
        key: _key.toString(),
      ),
    );
    _key++;
    notifyListeners();
  }
}
