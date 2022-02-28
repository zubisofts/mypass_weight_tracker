import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypass_weight_tracker/di/injector.dart';
import 'package:mypass_weight_tracker/helpers/app_utils.dart';
import 'package:mypass_weight_tracker/model/weight.dart';
import 'package:mypass_weight_tracker/view/home/add_weight_screen.dart';
import 'package:mypass_weight_tracker/view/home/widgets/empty_widget.dart';
import 'package:mypass_weight_tracker/viewmodel/auth_view_model.dart';
import 'package:mypass_weight_tracker/viewmodel/database_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    injector.get<DatabaseViewModel>().loadWeights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: injector.get<DatabaseViewModel>(),
        child: const WeightListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddEditWeightScreen()));
        },
        tooltip: 'Add Weight',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _logout() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    injector.get<AuthViewModel>().signOut();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}

class WeightListWidget extends StatefulWidget {
  const WeightListWidget({Key? key}) : super(key: key);

  @override
  State<WeightListWidget> createState() => _WeightListWidgetState();
}

class _WeightListWidgetState extends State<WeightListWidget> {
  @override
  Widget build(BuildContext context) {
    var database = Provider.of<DatabaseViewModel>(context, listen: true);
    List<Weight> weights = database.weights;
    if (weights.isEmpty) {
      return const EmptyWidget();
    }
    return ListView.separated(
      itemCount: weights.length,
      itemBuilder: (context, index) => ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${weights[index].value}",
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black)),
              const TextSpan(
                  text: " kg",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey)),
            ],
          ),
        ),
        subtitle: Text(
          DateFormat("EE MMMM d, y h:mm a").format(
            DateTime.fromMillisecondsSinceEpoch(weights[index].timestamp),
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddEditWeightScreen(weight: weights[index])));
                },
                icon: const Icon(Icons.edit_rounded)),
            const SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  _promptDelete(context, weights[index]);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                )),
          ],
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _promptDelete(BuildContext context, Weight weight) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('DELETE'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    injector.get<DatabaseViewModel>().deleteWeightItem(
                        weight.id!, onFailure: (String message) {
                      AppUtils.makeToast("Failed to delete weight: $message");
                    }, onSuccess: () {
                      AppUtils.makeToast("Item deleted successfully");
                    });
                  },
                ),
                TextButton(
                  child: const Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
