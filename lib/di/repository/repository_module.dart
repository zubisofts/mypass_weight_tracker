import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mypass_weight_tracker/repository/auth_repository.dart';
import 'package:mypass_weight_tracker/repository/database_repository.dart';

Future<void> init(GetIt injector) async {
injector.registerLazySingleton(() => AuthRepository(FirebaseAuth.instance));
injector.registerLazySingleton(() => DatabaseRepository(FirebaseFirestore.instance));
}