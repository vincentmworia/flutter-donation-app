import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';
import '../providers/fetch_firebase_data.dart';
import './blood_groups_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> homeData;
  var _init = true;
  var _isLoading = true;

  _fetchData() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero)
        .then((value) async =>
            await Provider.of<FetchFirebaseData>(context, listen: false)
                .getBloodGroups()
                .then((value) {
              homeData = value ?? [];
            }))
        .then((value) => setState(
              () => _isLoading = false,
            ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      _fetchData();

      _init = false;
    }
  }

  Widget _bloodData(
          BuildContext context, String title, String data, IconData icon) =>
      ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: null,
        label: Row(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Text(
              data,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      );

  _loadingStatus(bool status) => setState(
        () => _isLoading = status,
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("Blood Bank"), actions: [
        IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh))
      ]),
      drawer: const CustomDrawer( ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Blood Groups".toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: GridView(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 1 / 1,
                          // mainAxisExtent: 300,
                          mainAxisSpacing: 20,
                        ),
                        children: homeData
                            .map((data) => InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, BloodGroupsData.routeName,
                                      arguments: data),
                                  splashColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(25),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    elevation: 8,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    child:
                                        LayoutBuilder(builder: (context, cons) {
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
                                              (data["title"] as String)
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            ),
                                          ),
                                          _bloodData(
                                              context,
                                              "Donors",
                                              data["donors"] as String,
                                              Icons.person),
                                          _bloodData(
                                              context,
                                              "Quantity",
                                              "${data["quantity"]} L",
                                              Icons
                                                  .account_balance_wallet_outlined),
                                        ],
                                      );
                                    }),
                                  ),
                                ))
                            .toList()),
                  ),
                ],
              ),
            ),
    ));
  }
}
