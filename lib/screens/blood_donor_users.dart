import 'package:flutter/material.dart';

class BloodDonorUsers extends StatefulWidget {
  const BloodDonorUsers(this.donorData, {Key? key}) : super(key: key);
  final Map donorData;

  @override
  State<BloodDonorUsers> createState() => _BloodDonorUsersState();
}

class _BloodDonorUsersState extends State<BloodDonorUsers> {
  var _expand = false;

  @override
  Widget build(BuildContext context) {
    print(widget.donorData);
    return Stack(
      alignment: _expand ? Alignment.topRight : Alignment.centerRight,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: _expand ? 300 : 75,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: _expand
              ? Container()
              : Center(
                  child: Text(widget.donorData["full_name"],
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _expand = !_expand;
              });
            },
            icon: Icon(
              _expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 30,
              color: Colors.white,
            ))
      ],
    );
  }
}
