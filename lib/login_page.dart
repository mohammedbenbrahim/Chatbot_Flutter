import 'package:flutter/material.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String passwd = _passwordController.text;

    if (username == "admin" && passwd == "1234") {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/bot");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nom d'utilisateur ou mot de passe incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image(image: AssetImage("images/enset.png"),width: 200,),
            SizedBox(height: 10,),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text("Se connecter")),
          ],
        ),
      ),
    );
  }
}
