import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import '../core/color.dart';
import '../model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tipos de suscripción disponibles.
enum SubscriptionType { FREE, MONTHLY, SEMI_ANNUAL, YEARLY }

/// Pantalla para editar el tipo de suscripción de un usuario.
///
/// Permite seleccionar entre las opciones disponibles y guardar los cambios.
class EditSubscriptionScreen extends StatefulWidget {
  /// Usuario cuya suscripción será editada.
  final UserModel user;

  /// Constructor que recibe el [user] a editar.
  const EditSubscriptionScreen({super.key, required this.user});

  @override
  State<EditSubscriptionScreen> createState() => _EditSubscriptionScreenState();
}

class _EditSubscriptionScreenState extends State<EditSubscriptionScreen> {
  /// Suscripción seleccionada actualmente en la pantalla.
  late SubscriptionType _selectedSubscription;

  /// Indica si se está guardando la información.
  bool _isSaving = false;

  /// Convierte un [String] en un valor de [SubscriptionType].
  ///
  /// La conversión es insensible a mayúsculas y minúsculas,
  /// y maneja valores nulos o vacíos retornando FREE por defecto.
  SubscriptionType _subscriptionFromString(String? s) {
    if (s == null || s.isEmpty) {
      return SubscriptionType.FREE;
    }
    switch (s.toUpperCase()) {
      case 'MONTHLY':
        return SubscriptionType.MONTHLY;
      case 'SEMI_ANNUAL':
        return SubscriptionType.SEMI_ANNUAL;
      case 'YEARLY':
        return SubscriptionType.YEARLY;
      case 'FREE':
      default:
        return SubscriptionType.FREE;
    }
  }

  /// Convierte un valor de [SubscriptionType] a su representación en [String].
  String _subscriptionToString(SubscriptionType sub) {
    return sub.toString().split('.').last;
  }

  @override
  void initState() {
    super.initState();
    // Inicializa la suscripción seleccionada con el valor actual del usuario.
    _selectedSubscription = _subscriptionFromString(widget.user.subscription);
  }

  /// Guarda la suscripción seleccionada en el usuario y actualiza el controlador.
  ///
  /// Muestra un indicador de carga mientras se realiza la actualización.
  Future<void> _saveSubscription() async {
    setState(() {
      _isSaving = true;
    });

    UserModel updatedUser = widget.user;
    updatedUser.subscription = _subscriptionToString(_selectedSubscription);

    await UserController().updateUser(updatedUser);

    setState(() {
      _isSaving = false;
    });

    // Regresa a la pantalla anterior enviando el usuario actualizado.
    Navigator.of(context).pop(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loc.edit_subscription,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 12, 21),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveSubscription,
              color: Colors.white, // Ícono blanco
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: SubscriptionType.values.map((sub) {
            return RadioListTile<SubscriptionType>(
              title: Text(
                _subscriptionToString(sub),
                style: const TextStyle(color: Colors.white),
              ),
              value: sub,
              groupValue: _selectedSubscription,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _selectedSubscription = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
