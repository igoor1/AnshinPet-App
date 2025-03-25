import 'package:flutter/material.dart';
import 'package:anshinpet/ui/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _visible = false;

  void _login(context) {
    setState(() {
      String email = emailController.text;
      String password = passwordController.text;

      if (email == "email@123" && password == "123") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        final snack = SnackBar(
          content: Text("Erro - Email ou Senha Incorretos"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    });
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Image.asset("images/logo_full.png", height: 200),
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Digite o seu Email')),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Insira o Email";
                  }
                },
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Digite a sua Senha'),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: _visible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Insira a Senha";
                      }
                    },
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _login(context);
                    }
                  },
                  child: Text("Entrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
