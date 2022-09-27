import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiume/api/buyers.dart';
import 'package:fiume/models/buyer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OpRet {
  final UserCredential? credential;
  final Buyer? apiUser;
  final String? errorString;
  final dynamic error;

  OpRet({
    this.credential,
    this.apiUser,
    this.errorString,
    this.error,
  });
}

class ModUser {
  User? user;
  Buyer? apiUser;

  ModUser({
    this.user,
    this.apiUser
  });
}

class UserState extends StateNotifier<ModUser?> {
  UserState() : super(ModUser(
    user: FirebaseAuth.instance.currentUser,
  ));

  Future<OpRet> signup(String email, String password, String name) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      var ret = await getOrPostBuyers();

      if (ret.error != null) {
        FirebaseAuth.instance.signOut();

        return OpRet(
          errorString: 'Unable to complete operation',
          error: ret.error,
        );
      }

      state = ModUser(
        user: FirebaseAuth.instance.currentUser,
        apiUser: ret.response
      );

      return OpRet(
        credential: credential,
        apiUser: ret.response,
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

      var ret = await getOrPostBuyers();

      if (ret.error != null) {
        FirebaseAuth.instance.signOut();

        return OpRet(
          errorString: 'Unable to complete operation',
          error: ret.error,
        );
      }

      state = ModUser(
          user: FirebaseAuth.instance.currentUser,
          apiUser: ret.response
      );

      return OpRet(
        credential: credential,
        apiUser: ret.response,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return OpRet(
          errorString: 'No User Found for this Email',
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
    state = ModUser(
        user: null,
        apiUser: null
    );
  }

  Future<OpRet> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/user-not-found') {
        return OpRet(
          errorString: 'No User Found for this Email',
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

  Future<void> getApiUser() async {
    var ret = await getOrPostBuyers();

    if (ret.error != null) {
      FirebaseAuth.instance.signOut();
    }

    state = ModUser(
        user: FirebaseAuth.instance.currentUser,
        apiUser: ret.response
    );
  }
}

final userProvider = StateNotifierProvider<UserState, ModUser?>((ref) {
  return UserState();
});