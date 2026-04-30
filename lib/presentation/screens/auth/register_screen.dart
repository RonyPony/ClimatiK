import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState()=>_RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Registro')), body: Form(key: form, child: ListView(padding: const EdgeInsets.all(16), children: [
    TextFormField(decoration: const InputDecoration(labelText: 'Nombre'), validator: (v)=>v!=null&&v.length>2?null:'Mínimo 3 caracteres'),
    TextFormField(decoration: const InputDecoration(labelText: 'Email'), validator: (v)=>v!=null&&v.contains('@')?null:'Email inválido'),
    TextFormField(decoration: const InputDecoration(labelText: 'Contraseña'), validator: (v)=>v!=null&&v.length>=6?null:'Mínimo 6 caracteres', obscureText: true),
    const SizedBox(height: 20),
    ElevatedButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(context); }, child: const Text('Crear cuenta'))
  ])));
}
