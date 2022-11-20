import 'package:flutter/material.dart';

class BloodGroupsData extends StatelessWidget {
  const BloodGroupsData({Key? key}) : super(key: key);

  static const routeName = "/blood_groups_data";

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map;
    print(data);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("${data["title"]}"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
            // margin: ,
            padding: const EdgeInsets.all(15),
            child: Text(
              "${data["quantity"]} L of blood available\n${data["donors"]} donors\n",
              // textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),

        ],
      ),
    ));
  }
}
