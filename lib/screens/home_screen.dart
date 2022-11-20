import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home_screen";
  static const homeData = [
    {"title": "A +", "donors": "23", "quantity": "300"},
  ];

  Widget _bloodData(
          BuildContext context, String title, String data, IconData icon) =>
      ElevatedButton.icon(
        icon: Icon(icon),
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: null,
        label: Row(
          children: [
            Text(
              title,
            ),
            const Spacer(),
            Text(data),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 1 / 1,
            // mainAxisExtent: 300,
            mainAxisSpacing: 20,
          ),
          children: homeData
              .map((data) => Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    elevation: 8,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    child: LayoutBuilder(builder: (context, cons) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                )),
                            // margin: ,
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              (data["title"] as String).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          _bloodData(context, "Donors",
                              data["donors"] as String, Icons.person),
                          _bloodData(context, "Quantity",
                              "${data["quantity"]} L", Icons.numbers),
                        ],
                      );
                    }),
                  ))
              .toList(),
        ),
      ),
    ));
  }
}
