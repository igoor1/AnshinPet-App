import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _visible = false;

  void _visiblePassword() {
    setState(() {
      _visible = !_visible;
    });
  }

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
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: Text('Digite a sua Senha'),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _visible,
                ),
                IconButton(
                  onPressed: () {
                    _visiblePassword();
                  },
                  icon: Icon(
                    _visible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ],
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
