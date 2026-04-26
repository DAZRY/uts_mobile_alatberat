import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();
  final _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String?    _jwtToken;
  String?    _errorMessage;

  AuthStatus get status       => _status;
  UserModel? get user         => _user;
  String?    get jwtToken     => _jwtToken;
  String?    get errorMessage => _errorMessage;
  bool       get isLoading    => _status == AuthStatus.loading;

  Future<bool> register(String email, String password) async {
    _setStatus(AuthStatus.loading);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      await cred.user!.sendEmailVerification();
      _setStatus(AuthStatus.unauthenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _parseFirebaseError(e.code);
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );
      final firebaseUser = cred.user!;
      if (!firebaseUser.emailVerified) {
        _errorMessage = 'EMAIL_NOT_VERIFIED';
        _setStatus(AuthStatus.error);
        return false;
      }
      final firebaseToken = await firebaseUser.getIdToken();
      final result = await _repo.verifyTokenWithBackend(firebaseToken!);
      _jwtToken = result['access_token'];
      _user     = UserModel.fromJson(result['user']);
      _setStatus(AuthStatus.authenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _parseFirebaseError(e.code);
      _setStatus(AuthStatus.error);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user     = null;
    _jwtToken = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  void _setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }

  String _parseFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use': return 'Email sudah terdaftar';
      case 'invalid-email':        return 'Format email tidak valid';
      case 'weak-password':        return 'Password minimal 6 karakter';
      case 'user-not-found':       return 'Email tidak ditemukan';
      case 'wrong-password':       return 'Password salah';
      default:                     return 'Terjadi kesalahan: $code';
    }
  }
}