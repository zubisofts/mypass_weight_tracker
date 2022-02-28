import 'package:flutter/material.dart';
import 'package:mypass_weight_tracker/di/injector.dart';
import 'package:mypass_weight_tracker/model/weight.dart';
import 'package:mypass_weight_tracker/view/home/add_edit_weight_form.dart';
import 'package:mypass_weight_tracker/viewmodel/database_view_model.dart';
import 'package:provider/provider.dart';

class AddEditWeightScreen extends StatefulWidget {
  final Weight? weight;

  const AddEditWeightScreen({Key? key, this.weight}) : super(key: key);

  @override
  State<AddEditWeightScreen> createState() => _AddEditWeightScreenState();
}

class _AddEditWeightScreenState extends State<AddEditWeightScreen> {
  var databaseViewModel = injector.get<DatabaseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider<DatabaseViewModel>.value(
      value: databaseViewModel,
      child: AddEditWeightForm(weight: widget.weight),
    ));
  }
}
