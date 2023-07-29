import 'package:flutter/material.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';

class CardContainer extends StatelessWidget {
  CardContainer({
    Key? key,
    required this.child,
    required this.onTap,
    required this.borderColor,
  }) : super(key: key);

  final Color borderColor;
  final void Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16.0),  //外余白
        padding: const EdgeInsets.all(8.0),  //内余白
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: child,
      ),
    );
  }
}