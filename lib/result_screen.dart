import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final String label;
  final double confidence;

  const ResultScreen({
    super.key,
    required this.image,
    required this.label,
    required this.confidence,
  });

  String get _name => label.replaceAll('___', ': ').replaceAll('_', ' ');

  String get _advice {
    if (confidence < 0.6) {
      return 'The model is not sure. Retake the photo: one leaf, close up, good light, plain background.';
    }
    if (label.endsWith('healthy')) {
      return 'The leaf looks healthy. Keep monitoring and maintain good watering and spacing.';
    }
    return 'Remove affected leaves, avoid overhead watering, and consider a suitable treatment. Consult a local agriculture officer to confirm.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(image, height: 320, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(_name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: confidence, minHeight: 8),
          const SizedBox(height: 20),
          const Text('Suggested action',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_advice, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}