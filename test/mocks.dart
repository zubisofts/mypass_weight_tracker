import 'package:mocktail/mocktail.dart';
import 'package:mypass_weight_tracker/repository/auth_repository.dart';
import 'package:mypass_weight_tracker/repository/database_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDatabaseRepository extends Mock implements DatabaseRepository {}