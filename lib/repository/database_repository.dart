import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:mypass_weight_tracker/model/error_model.dart';
import 'package:mypass_weight_tracker/model/weight.dart';

class DatabaseRepository {
  final FirebaseFirestore _firestore;

  DatabaseRepository(this._firestore);

  Future<Either<ErrorModel, String>> addWeight(Weight weight) async {
    try {
      DocumentReference docRef = _firestore.collection('weights').doc();
      await docRef.set(weight.copyWith(id: docRef.id).toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(ErrorModel("Failed to add weight data", e.code));
    } on SocketException catch (_) {
      return Left(ErrorModel("No internet connection", "400"));
    } catch (e) {
      return Left(ErrorModel("Unable to add item", "400"));
    }
  }

  Stream<List<Weight>> getWeights(String userId) {
    return _firestore
        .collection('weights')
        .orderBy('timestamp', descending: true)
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Weight.fromMap(doc.data())).toList());
  }

  Future<Either<ErrorModel, String>> deleteWeight(String id) async {
    try {
      DocumentReference docRef = _firestore.collection('weights').doc(id);
      await docRef.delete();
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(ErrorModel("Unable to delete data", e.code));
    }
  }

  Future<Either<ErrorModel, String>> updateWeight(Weight weight) async {
    try {
      DocumentReference docRef =
          _firestore.collection('weights').doc(weight.id);
      await docRef.update(weight.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left(ErrorModel("Failed to update weight data", e.code));
    } on SocketException catch (_) {
      return Left(ErrorModel("No internet connection", "400"));
    } catch (e) {
      return Left(ErrorModel("Unable to update item", "400"));
    }
  }
}
