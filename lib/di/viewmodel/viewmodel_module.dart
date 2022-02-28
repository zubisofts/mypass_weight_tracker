import 'package:get_it/get_it.dart';
import 'package:mypass_weight_tracker/viewmodel/auth_view_model.dart';
import 'package:mypass_weight_tracker/viewmodel/database_view_model.dart';

Future<void> init(GetIt injector) async {
  injector.registerLazySingleton(() => AuthViewModel(injector.get()));
  injector.registerLazySingleton(() => DatabaseViewModel(injector.get()));
}
