import 'package:edo_sistema/view/login/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  telaInicial() async {
    Future.delayed(
      const Duration(seconds: 3),
    ).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Login(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    telaInicial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Image.asset(
            'imagens/logo.png',
          ),
        ),
      ),
    );
  }
}
