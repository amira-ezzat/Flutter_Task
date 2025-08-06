// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:http/http.dart' as http;
//
// class VoiceOrderTestPage extends StatefulWidget {
//   const VoiceOrderTestPage({super.key});
//
//   @override
//   State<VoiceOrderTestPage> createState() => _VoiceOrderTestPageState();
// }
//
// class _VoiceOrderTestPageState extends State<VoiceOrderTestPage> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = '';
//   List<String> _products = [];
//
//   final String openAiKey = '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'; // ← ضيفي هنا API Key
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//
//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(onResult: (result) {
//           setState(() {
//             _text = result.recognizedWords;
//           });
//         });
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   Future<void> _processTextWithAI() async {
//     final prompt = '''
// Extract only the product names from this Arabic sentence and return them as a JSON array:
// "$_text"
// ''';
//
//     final response = await http.post(
//       Uri.parse("https://api.openai.com/v1/chat/completions"),
//       headers: {
//         "Authorization": "Bearer $openAiKey",
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "model": "gpt-4",
//         "messages": [
//           {"role": "system", "content": "You extract product names from Arabic speech"},
//           {"role": "user", "content": prompt}
//         ]
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final content = data['choices'][0]['message']['content'];
//       final result = jsonDecode(content);
//
//       setState(() {
//         _products = List<String>.from(result);
//       });
//     } else {
//       print(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error from API")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Voice AI Order Test")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton.icon(
//               icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
//               label: Text(_isListening ? "Listening..." : "Start Recording"),
//               onPressed: _listen,
//             ),
//             SizedBox(height: 16),
//             Text("You said:", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(_text, style: TextStyle(fontSize: 16)),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _processTextWithAI,
//               child: Text("طلب المنتجات"),
//             ),
//             SizedBox(height: 16),
//             if (_products.isNotEmpty) ...[
//               Text("Products Found:", style: TextStyle(fontWeight: FontWeight.bold)),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _products.length,
//                   itemBuilder: (_, index) => ListTile(
//                     leading: Icon(Icons.shopping_bag),
//                     title: Text(_products[index]),
//                   ),
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
