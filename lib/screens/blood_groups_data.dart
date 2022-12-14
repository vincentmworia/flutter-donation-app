import 'package:flutter/material.dart';

import '../widgets/blood_donor_users.dart';


class BloodGroupsData extends StatelessWidget {
  const BloodGroupsData({Key? key}) : super(key: key);

  static const routeName = "/blood_groups_data";

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map;
    final donors = data["data"] as List;
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
          ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Blood Group ${data["title"]} request successful"),
                  duration: const Duration(seconds: 1),
                ));
              },
              child: const Text("Request All")),
          Expanded(
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    final donorData = donors[index] as Map;
                    // print(donorData);
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: BloodDonorUsers(donorData),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: donors.length))
        ],
      ),
    ));
  }
}
