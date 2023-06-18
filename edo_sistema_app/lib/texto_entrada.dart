import 'package:flutter/material.dart';

class TextoEntrada extends StatelessWidget {
  final String? labeltext;
  final TextEditingController? controller;
  final TextInputType? tipoTeclado;
  final Function(String)? onchanged;
  final bool senha;
  final Function()? funcIcon;
  final IconData? icon;
  const TextoEntrada({
    Key? key,
    this.labeltext,
    this.controller,
    this.tipoTeclado,
    this.onchanged,
    this.senha = false,
    this.funcIcon,
    this.icon,
  }) : super(key: key);

  const TextoEntrada.senha({
    Key? key,
    this.labeltext,
    this.controller,
    this.tipoTeclado,
    this.onchanged,
    this.senha = true,
    this.funcIcon,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, top: 10, right: 0),
      child: TextField(
        obscureText: senha,
        onChanged: onchanged,
        keyboardType: tipoTeclado,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          labelText: labeltext,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black38,
            ),
          ),
          suffixIcon: funcIcon != null
              ? IconButton(
                  onPressed: funcIcon,
                  icon: Icon(
                    icon,
                    color: Colors.black38,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
