import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Metodo para iniciar sesión con email y contraseña usando Firebase.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario.
  /// - [password]: Contraseña del usuario.
  ///
  /// Retorna el UID del usuario si el inicio de sesión es exitoso,
  /// o lanza una excepción con el mensaje de error en caso contrario.
  Future<String?> signInEAndP(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Metodo para iniciar sesión con Google usando Firebase.
  ///
  /// Retorna el objeto [User] de Firebase si el inicio es exitoso,
  /// o lanza una excepción en caso de fallo.
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userGoogle = await GoogleSignIn().signIn();
      if (userGoogle == null) {
        // El usuario canceló el login con Google
        throw Exception('Inicio de sesión con Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth = await userGoogle.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final User user = userCredential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Metodo para crear un nuevo usuario con email y contraseña.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario.
  /// - [password]: Contraseña del usuario.
  ///
  /// Retorna el objeto [User] creado o lanza una excepción con el mensaje de error.
  Future<User?> createUser(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Metodo para enviar un correo para recuperar la contraseña.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario al que se enviará el email.
  ///
  /// Lanza una excepción en caso de error.
  Future<void> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
