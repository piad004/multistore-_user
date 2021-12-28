import 'package:flutter/material.dart';
import 'package:user/Themes/colors.dart';

class ReusableCard extends StatefulWidget {
  final Widget cardChild;
  final Function onPress;

  ReusableCard({this.cardChild, this.onPress});

  @override
  _ReusableCardState createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return GestureDetector(
      onTap: widget.onPress,
      behavior: HitTestBehavior.opaque,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          child: widget.cardChild,
          alignment: Alignment.center,
          padding: EdgeInsets.all(15.3),
          decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border(
                top: BorderSide.none,
                left: BorderSide.none,
                right:
                    BorderSide(color: kHintColor.withOpacity(0.2), width: 0.5),
                bottom:
                    BorderSide(color: kHintColor.withOpacity(0.2), width: 0.5)),
          ),
        ),
      ),
    );
  }
}
