import 'package:anshinpet/res/components/round_buton.dart';
import 'package:anshinpet/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _visible = true;

  void _visiblePassword() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewMode = Provider.of<AuthViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
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
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Insira o Email";
                  }
                  return null;
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
                    controller: _passwordController,
                    obscureText: _visible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Insira a Senha";
                      }
                      return null;
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
              SizedBox(height: height * .085),
              RoundButton(
                title: 'Entrar', 
                loading: authViewMode.loading,
                onPress: (){
                  if (_formKey.currentState?.validate() ?? false) {
                    Map data = {
                      'email': _emailController.text.toString(),
                      'senha': _passwordController.text.toString()
                    };
                    authViewMode.loginApi(data, context);
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}