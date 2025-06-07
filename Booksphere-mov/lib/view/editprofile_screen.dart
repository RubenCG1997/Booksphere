import 'package:flutter/material.dart';
import '../controller/user_controller.dart';
import '../core/color.dart';
import '../model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla para editar el perfil de usuario.
///
/// Permite modificar el nombre de usuario y el correo electrónico.
/// Muestra un botón para guardar los cambios.
class Editprofile extends StatefulWidget {
  /// Datos del usuario actual a editar.
  final UserModel? user;

  /// Constructor que recibe el [user] a editar.
  const Editprofile({super.key, required this.user});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  /// Controlador para el campo de nombre de usuario.
  late TextEditingController _usernameController;

  /// Controlador para el campo de correo electrónico.
  late TextEditingController _emailController;

  /// Bandera para indicar si se están guardando los cambios.
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username);
    _emailController = TextEditingController(text: widget.user?.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc  = AppLocalizations.of(context)!;
    return Scaffold(
      /// AppBar con íconos y texto blanco.
      appBar: AppBar(
        title: Text(
          loc.edit_profile,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 96, 12, 21),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _saveChanges,
            ),
        ],
      ),

      /// Cuerpo con campos de texto en blanco.
      body: Container(
        color: AppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Campo de texto para el nombre de usuario.
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.username,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Campo de texto para el correo electrónico.
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),

              /// Indicador de carga mientras se guardan los datos.
              if (_isSaving)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Guarda los cambios del perfil y actualiza los datos del usuario.
  ///
  /// Al finalizar, regresa a la pantalla anterior con el usuario actualizado.
  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    UserModel? updatedUser = widget.user;
    updatedUser?.username = _usernameController.text.trim();
    updatedUser?.email = _emailController.text.trim();

    await UserController().updateUser(updatedUser);

    setState(() {
      _isSaving = false;
    });

    Navigator.of(context).pop(updatedUser);
  }
}
