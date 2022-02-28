import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mypass_weight_tracker/model/error_model.dart';

import 'mocks.dart';

void main() {
  MockAuthRepository mockAuthRepo = MockAuthRepository();
  // StreamController<MyAppUser> onAuthStateChangedController;

  setUp(() {
    // onAuthStateChangedController = StreamController<MyAppUser>();
  });

  tearDown(() {
    // onAuthStateChangedController.close();
  });

  void stubMockFirebaseAnonymousSignInReturnsId() {
    when(() => mockAuthRepo.signInUser()).thenAnswer((_) =>
        Future<Either<ErrorModel, String>>(
            () => const Right<ErrorModel, String>("FRJO123")));
  }

  test("Sigin anonymously should return success with user id", () async {
    stubMockFirebaseAnonymousSignInReturnsId();
    expect(await mockAuthRepo.signInUser(),
        const Right<ErrorModel, String>("FRJO123"));
  });
}
