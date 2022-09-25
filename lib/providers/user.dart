import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OpRet {
  final UserCredential? credential;
  final String? errorString;
  final dynamic error;

  OpRet({
    this.credential,
    this.errorString,
    this.error,
  });
}

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  Future<OpRet> signup(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      state = credential.user;

      return OpRet(
        credential: credential,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return OpRet(
          errorString: 'The Password Provided is too weak',
          error: e,
        );
      } else if (e.code == 'email-already-in-use') {
        return OpRet(
          errorString: 'An account already exists for this email',
          error: e,
        );
      }
    } catch (e) {
      return OpRet(
        errorString: 'An Unknown Error Occured',
        error: e,
      );
    }

    return OpRet();
  }

  Future<OpRet> signin(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      state = credential.user;

      return OpRet(
        credential: credential,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return OpRet(
          errorString: 'No User Found for that Email',
          error: e,
        );
      } else if (e.code == 'wrong-password') {
        return OpRet(
          errorString: 'The Password Provided is incorrect',
          error: e,
        );
      }
    } catch (e) {
      return OpRet(
        errorString: 'An Unknown Error Occured',
        error: e,
      );
    }

    return OpRet();
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});