import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Image.asset("images/logo_full.png", height: 200),
            ),
            TextField(
              decoration: InputDecoration(label: Text('Digite o seu Email')),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Digite a sua Senha'),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: FloatingActionButton(
                onPressed: () {},
                child: Text("Entrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
