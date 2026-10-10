import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Prediction {
  final String label;
  final double confidence;
  Prediction(this.label, this.confidence);
}

class Classifier {
  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> load() async {
    _interpreter = await Interpreter.fromAsset('assets/crop_model.tflite');
    final raw = await rootBundle.loadString('assets/labels.txt');
    _labels = raw.split('\n').where((l) => l.trim().isNotEmpty).toList();
  }

  Prediction predict(File file) {
    final bytes = file.readAsBytesSync();
    final decoded = img.decodeImage(bytes)!;
    final resized = img.copyResize(decoded, width: 224, height: 224);

    // Input shape [1, 224, 224, 3], pixel values 0-255 as floats
    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final p = resized.getPixel(x, y);
          return [p.r.toDouble(), p.g.toDouble(), p.b.toDouble()];
        }),
      ),
    );

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
    _interpreter.run(input, output);

    final scores = output[0];
    final best = scores.reduce(max);
    final index = scores.indexOf(best);
    return Prediction(_labels[index], best);
  }
}