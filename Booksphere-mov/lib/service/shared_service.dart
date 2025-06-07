import 'package:shared_preferences/shared_preferences.dart';

/// Obtiene el UID guardado en las preferencias locales.
///
/// Retorna el UID almacenado como [String] si existe,
/// o `null` si no está guardado.
Future<String?> getSavedUid() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}
