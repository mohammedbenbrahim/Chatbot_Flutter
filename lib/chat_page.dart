import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String openAIKey = "sk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

class ChatPage extends StatefulWidget {
  final String username;
  const ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> messages = [];

  Future<void> _sendMessage(String text) async {
    setState(() {
      messages.add({"role": "user", "content": text});
    });

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openAIKey"
      },
      body: jsonEncode({
        "model": "gpt-4o-mini", // أو gpt-3.5-turbo
        "messages": messages
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data["choices"][0]["message"]["content"];
      setState(() {
        messages.add({"role": "assistant", "content": reply});
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 200);
      });
    } else {
      setState(() {
        messages.add({"role": "assistant", "content": "[Erreur API]"});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DWM Chatbot", style: TextStyle(color: Theme.of(context).indicatorColor)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/");
            },
            icon: Icon(Icons.logout, color: Theme.of(context).indicatorColor),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,

              itemBuilder: (context, index) {
                final role = messages[index]['role'];
                final content = messages[index]['content'] ?? "";

                return Align(
                  alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                    color: messages[index]['role']=='user'
                        ?Color.fromARGB(30, 0, 255, 0)
                        : Colors.white
                    ,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black26, 
                      ),
                    ),
                    child: Text(content),
                  ),
                );
              }

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Votre message",
                      suffixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
