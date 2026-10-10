// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'result_screen.dart';
// import 'classifier.dart';
// void main() {
//   runApp(const CropDoctorApp());
// }

// class CropDoctorApp extends StatelessWidget {
//   const CropDoctorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CropDoctor',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ImagePicker _picker = ImagePicker();
//   File? _image; 
//   // last edit by adarsh , mark ----->
//    final Classifier _classifier = Classifier();
//   Prediction? _result;
//   bool _ready = false;

//    @override
//   void initState() {
//     super.initState();
//     _classifier.load().then((_) {
//       setState(() => _ready = true);
//     }).catchError((e) {
//       debugPrint('MODEL LOAD ERROR: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Model load error: $e')),
//         );
//       }
//     });
//   }
//     Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: source,
//         imageQuality: 85,
//       );
//       if (picked == null) return;

//       final file = File(picked.path);
//       setState(() => _image = file);

//       if (!_ready) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Model is still loading, try again')),
//           );
//         }
//         return;
//       }

//       final result = _classifier.predict(file);
//       if (!mounted) return;
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ResultScreen(
//             image: file,
//             label: result.label,
//             confidence: result.confidence,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint('PICK/PREDICT ERROR: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('CropDoctor'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.green.shade200),
//                 ),
//                 child: _image == null
//                     ? const Center(
//                         child: Text(
//                           'Take a photo of a crop leaf\nto check for disease',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       )
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(_image!, fit: BoxFit.cover),
//                       ),
//               ),
//             ),
//                         if (_result != null) ...[
//               const SizedBox(height: 16),
//               Text(
//                 _result!.label.replaceAll('___', ': ').replaceAll('_', ' '),
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               Text('Confidence: ${(_result!.confidence * 100).toStringAsFixed(1)}%'),
//             ],
            
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: FilledButton.icon(
//                 onPressed: () => _pickImage(ImageSource.camera),
//                 icon: const Icon(Icons.camera_alt),
//                 label: const Text('Take photo'),
//               ),
//             ),
//             const SizedBox(height: 12),
//                         const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: OutlinedButton.icon(
//                 onPressed: () => _pickImage(ImageSource.gallery),
//                 icon: const Icon(Icons.photo_library),
//                 label: const Text('Choose from gallery'),
//               ),
//             ),
//             if (_image != null) ...[
//               const SizedBox(height: 12),
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 52,
//               //   child: FilledButton.tonalIcon(
//               //     onPressed: () {
//               //       Navigator.push(
//               //         context,
//               //         MaterialPageRoute(
//               //           builder: (_) => ResultScreen(image: _image!),
//               //         ),
//               //       );
//               //     },
//               //     icon: const Icon(Icons.search),
//               //     label: const Text('Analyze'),
//               //   ),
//               // ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'classifier.dart';
import 'result_screen.dart';

void main() {
  runApp(const CropDoctorApp());
}

class CropDoctorApp extends StatelessWidget {
  const CropDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropDoctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final Classifier _classifier = Classifier();
  File? _image;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _classifier.load().then((_) {
      if (mounted) setState(() => _ready = true);
    }).catchError((e) {
      debugPrint('MODEL LOAD ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Model load error: $e')),
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked == null) return;

      final file = File(picked.path);
      setState(() => _image = file);

      if (!_ready) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Model is still loading, try again')),
          );
        }
        return;
      }

      final result = _classifier.predict(file);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: file,
            label: result.label,
            confidence: result.confidence,
          ),
        ),
      );
    } catch (e) {
      debugPrint('PICK/PREDICT ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CropDoctor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: _image == null
                    ? const Center(
                        child: Text(
                          'Take a photo of a crop leaf\nto check for disease',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take photo'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Choose from gallery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}