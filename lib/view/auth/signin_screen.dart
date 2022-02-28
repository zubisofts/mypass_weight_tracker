import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mypass_weight_tracker/di/injector.dart';
import 'package:mypass_weight_tracker/viewmodel/auth_view_model.dart';
import 'package:mypass_weight_tracker/viewmodel/base_view_model.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = injector.get<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Tracker"),
      ),
      body: Center(
        child: ChangeNotifierProvider<AuthViewModel>.value(
            value: authViewModel,
            builder: (_, snapshot) {
              log("Status:${authViewModel.state}");
              return const SignInWidget();
            }),
      ),
    );
  }
}

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ElevatedButton(
        onPressed: () {
          authViewModel.signIn();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (authViewModel.state == AppState.loading)
              const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: authViewModel.state == AppState.loading
                    ? const Text('Signing in...')
                    : const Text('Sign In to continue')),
          ],
        ));
  }
}
