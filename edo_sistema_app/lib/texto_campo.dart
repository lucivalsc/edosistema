import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextoCampo extends StatelessWidget {
  final String? labeltext;
  final TextEditingController? controller;
  final TextInputType? tipoTeclado;
  final Function(String)? onchanged;
  final Function()? funcIcon;
  final IconData? icon;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final Function()? ontap;
  final FocusNode? focusNode;
  final bool senha;
  final bool readonly;
  final TextInputFormatter? formatter;
  const TextoCampo({
    Key? key,
    this.labeltext,
    this.controller,
    this.tipoTeclado,
    this.onchanged,
    this.funcIcon,
    this.icon,
    this.textInputAction,
    this.onSubmitted,
    this.ontap,
    this.focusNode,
    this.senha = false,
    this.readonly = false,
    this.formatter,
  }) : super(key: key);

  const TextoCampo.senha({
    Key? key,
    this.labeltext,
    this.controller,
    this.tipoTeclado,
    this.onchanged,
    this.funcIcon,
    this.icon,
    this.textInputAction,
    this.onSubmitted,
    this.ontap,
    this.focusNode,
    this.senha = true,
    this.readonly = false,
    this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      height: 45,
      child: TextField(
        focusNode: focusNode,
        obscureText: senha,
        onChanged: onchanged,
        keyboardType: tipoTeclado,
        controller: controller,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        readOnly: readonly,
        inputFormatters: formatter != null
            ? [
                FilteringTextInputFormatter.digitsOnly,
                formatter!,
              ]
            : [],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          labelText: labeltext,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(),
          ),
          suffixIcon: funcIcon != null
              ? IconButton(
                  onPressed: funcIcon,
                  icon: Icon(
                    icon,
                  ),
                )
              : null,
        ),
        onTap: ontap,
      ),
    );
  }
}
