// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CheckBoxx extends StatefulWidget {
  const CheckBoxx({super.key, this.value, this.onChanged});

  final void Function(bool?)? onChanged;
  final bool? value;

  @override
  State<CheckBoxx> createState() => _CheckBoxxState();
}

class _CheckBoxxState extends State<CheckBoxx> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      activeColor: const Color(0xff792A90),
      onChanged:
          widget.onChanged ??
          (bool? value) {
            if (value != null) {
              setState(() {
                _checked = value;
              });
            }
          },
      value: widget.value ?? _checked,
    );
  }
}
