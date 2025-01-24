import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'prompt.dart';

class AIEditPage extends StatefulWidget {
  final File imageFile;

  const AIEditPage({super.key, required this.imageFile});

  @override
  _AIEditPageState createState() => _AIEditPageState();
}

class _AIEditPageState extends State<AIEditPage> {
  Uint8List? editedImage;
  String? aiTextResult;
  final TextEditingController _promptController = TextEditingController();
  final List<Map<String, String>> chatHistory = [];
  bool isLoading = false;

  Future<DataPart> fileToPart(String mimeType, File file) async {
    return DataPart(mimeType, await file.readAsBytes());
  }

  // showPrompt 옵션이 있는 메서드
  Future<void> _generateAIResult(String prompt,
      {bool showPrompt = true}) async {
    setState(() {
      isLoading = true;
    });
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      setState(() {
        chatHistory.add({
          'prompt': showPrompt ? prompt : '',
          'response': 'Error: API key not found'
        });
      });
      return;
    }

    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

    try {
      final imagePart = await fileToPart('image/jpeg', widget.imageFile);

      print('Sending request with prompt and image');
      final response = await model.generateContent([
        Content.multi([TextPart(prompt), imagePart])
      ]);
      print('Received response: ${response.text}');

      setState(() {
        aiTextResult = response.text;
        chatHistory.add({
          'prompt': showPrompt ? prompt : '',
          'response': aiTextResult ?? 'Image edited successfully'
        });
      });
    } catch (e) {
      print('Error generating AI result: $e');
      setState(() {
        chatHistory.add({
          'prompt': showPrompt ? prompt : '',
          'response': 'Error: Unable to generate result'
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitPrompt() {
    final prompt = _promptController.text;
    if (prompt.isNotEmpty) {
      _generateAIResult(prompt);
      _promptController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          // [1] jellyfish 분류
          IconButton(
            icon: const Icon(
              Icons.science,
              color: Color.fromARGB(255, 243, 111, 111),
            ),
            onPressed: () {
              _generateAIResult(Prompts.jellyPrompt, showPrompt: false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          editedImage != null
              ? Image.memory(
                  editedImage!,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                )
              : Image.file(
                  widget.imageFile,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Error loading image'));
                  },
                ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = chatHistory[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(
                                '${chat['prompt']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                '${chat['response']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 12),
                              controller: _promptController,
                              decoration: InputDecoration(
                                hintText: 'Enter your prompt here...',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12.0),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: _submitPrompt,
                                ),
                              ),
                              onSubmitted: (value) => _submitPrompt(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
