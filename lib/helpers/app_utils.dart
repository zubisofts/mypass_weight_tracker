import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  AppUtils._();

  static void makeToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0);
  }
}
