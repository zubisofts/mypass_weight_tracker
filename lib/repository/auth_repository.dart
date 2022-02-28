import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypass_weight_tracker/model/error_model.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepository(this.firebaseAuth);

  Stream<User?> listenToAuthChange() {
    return firebaseAuth.authStateChanges();
  }

  Future<Either<ErrorModel, String>> signInUser() async {
    try {
      final authResult = await firebaseAuth.signInAnonymously();
      return Right(authResult.user!.uid);
    } on FirebaseException catch (e) {
      return Left(ErrorModel(e.message!, e.code));
    } catch (e) {
      return Left(
          ErrorModel("Oops something went wrong:${e.toString()}", "400"));
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      log('${e.message}');
    } catch (e) {
      log(e.toString());
    }
  }
}
