import 'package:flutter/material.dart';

class BloodDonorUsers extends StatefulWidget {
  const BloodDonorUsers(this.donorData, {Key? key}) : super(key: key);
  final Map donorData;

  @override
  State<BloodDonorUsers> createState() => _BloodDonorUsersState();
}

class _BloodDonorUsersState extends State<BloodDonorUsers> {
  var _expand = false;
  var _visibility = true;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 18);
    print(widget.donorData);
    return Stack(
      alignment: _expand ? Alignment.topRight : Alignment.centerRight,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: _expand ? 300 : 75,
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: _expand
              ? LayoutBuilder(builder: (context, cons) {
                  return Visibility(
                    visible: _visibility,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.donorData["email"],
                          style: textStyle,
                        ),
                        Text(
                          widget.donorData["full_name"],
                          style: textStyle,
                        ),
                        Text(
                          widget.donorData["gender"],
                          style: textStyle,
                        ),
                        Text(
                          widget.donorData["age"],
                          style: textStyle,
                        ),
                        Text(
                          widget.donorData["blood_type"],
                          style: textStyle,
                        ),
                        Text(
                          widget.donorData["location"],
                          style: textStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "${widget.donorData["full_name"]} request successful"),
                                duration: const Duration(seconds: 1),
                              ));
                            },
                            child: const Text("Request Donation"))
                      ],
                    ),
                  );
                })
              : Center(
                  child: Text(widget.donorData["full_name"],
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 20,
                      )),
                ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _visibility = false;
                _expand = !_expand;
              });
              Future.delayed(const Duration(milliseconds: 300))
                  .then((value) => setState(
                        () => _visibility = true,
                      ));
            },
            icon: Icon(
              _expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
    );
  }
}
