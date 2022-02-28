import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypass_weight_tracker/helpers/app_utils.dart';
import 'package:mypass_weight_tracker/model/weight.dart';
import 'package:mypass_weight_tracker/viewmodel/base_view_model.dart';
import 'package:mypass_weight_tracker/viewmodel/database_view_model.dart';
import 'package:provider/provider.dart';

class AddEditWeightForm extends StatefulWidget {
  final Weight? weight;

  const AddEditWeightForm({Key? key, this.weight}) : super(key: key);

  @override
  _AddEditWeightFormState createState() => _AddEditWeightFormState();
}

class _AddEditWeightFormState extends State<AddEditWeightForm> {
  double _weight = 0;

  late final TextEditingController _weightTextController;

  @override
  void initState() {
    super.initState();
    if (widget.weight != null) {
      log('WEIGHT VALUE: ${widget.weight!.value}');
      setState(() {
        _weight = widget.weight!.value.toDouble();
      });
    }
    _weightTextController =
        TextEditingController(text: _weight.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    var databaseViewModel = Provider.of<DatabaseViewModel>(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.of(context).size.height * 0.2),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("What is your current weight?",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(height: 32 * 2),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: _weight.toStringAsFixed(0),
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black)),
                          const TextSpan(
                              text: "KG",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    Slider(
                        max: 1000,
                        min: 0,
                        divisions: 1000,
                        label: _weight.toStringAsFixed(0),
                        value: _weight,
                        onChanged: (val) {
                          setState(() {
                            _weight = val;
                            _weightTextController.text =
                                _weight.toStringAsFixed(0);
                            // double.parse(val.toStringAsPrecision(1));
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 32 * 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    controller: _weightTextController,
                    decoration: const InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(fontSize: 45),
                        filled: true),
                    style: const TextStyle(fontSize: 45),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        if (double.parse(val) <= 1000) {
                          setState(() {
                            setState(() {
                              _weight = double.parse(val);
                            });
                          });
                        } else {
                          setState(() {
                            _weightTextController.text =
                                _weight.toStringAsFixed(0);
                          });
                        }
                      } else {
                        setState(() {
                          _weight = 0;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ChangeNotifierProvider<DatabaseViewModel>.value(
                value: databaseViewModel,
                builder: (_, __) => ElevatedButton(
                    onPressed: databaseViewModel.state == AppState.loading
                        ? null
                        : () => _processForm(databaseViewModel),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        databaseViewModel.state == AppState.loading
                            ? widget.weight != null
                                ? "Updating Data"
                                : "Saving Data"
                            : widget.weight != null
                                ? "Update Data"
                                : "Save Data",
                        style: const TextStyle(fontSize: 18),
                      ),
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }

  _processForm(DatabaseViewModel databaseViewModel) async {
    if (widget.weight != null) {
      databaseViewModel
          .updateWeight(widget.weight!.copyWith(value: _weight.round()),
              onFailure: (String message) {
        AppUtils.makeToast(message);
      }, onSuccess: () {
        Navigator.of(context).pop();
        AppUtils.makeToast("Weight updated successfully");
      });
    } else {
      databaseViewModel.addWeight(
          Weight(
              userId: '',
              value: _weight.round(),
              timestamp: DateTime.now().millisecondsSinceEpoch),
          onFailure: (String message) {
        AppUtils.makeToast(message);
      }, onSuccess: () {
        Navigator.of(context).pop();
        AppUtils.makeToast("Weight added successfully");
      });
    }
  }
}
