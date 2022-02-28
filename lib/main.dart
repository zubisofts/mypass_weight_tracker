import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypass_weight_tracker/di/injector.dart' as di;
import 'package:mypass_weight_tracker/di/injector.dart';
import 'package:mypass_weight_tracker/view/auth/signin_screen.dart';
import 'package:mypass_weight_tracker/view/home/home_screen.dart';
import 'package:mypass_weight_tracker/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: injector.get<AuthViewModel>(),
      child: MaterialApp(
        title: 'Weight Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context);
    return authViewModel.isSignedIn ? const HomeScreen() : const SignInScreen();
  }
}
