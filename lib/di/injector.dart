import 'package:get_it/get_it.dart';
import 'package:mypass_weight_tracker/di/repository/repository_module.dart'
    as repository_module;
import 'package:mypass_weight_tracker/di/viewmodel/viewmodel_module.dart' as viewmodel_modulw;

final injector = GetIt.instance;

Future<void> setup() async {
  repository_module.init(injector);
  viewmodel_modulw.init(injector);
}
