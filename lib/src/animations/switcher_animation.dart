import 'package:flutter/material.dart';

class SwitcherAnimationPage extends StatelessWidget {
  const SwitcherAnimationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Switcher Animation'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSwitcher(
              switcherHeight: 50,
              switcherWidth: 100,
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class CustomSwitcher extends StatefulWidget {
  final double switcherHeight;
  final double switcherWidth;
  final Color disabledColor;
  final Color enabledColor;
  final Color innerCircleColor;

  const CustomSwitcher({
    required this.switcherHeight,
    required this.switcherWidth,
    this.disabledColor = Colors.red,
    this.enabledColor = const Color.fromRGBO(2, 212, 69, 1),
    this.innerCircleColor = Colors.white,
    super.key,
  });

  @override
  State<CustomSwitcher> createState() => _CustomSwitcherState();
}

class _CustomSwitcherState extends State<CustomSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Color?> colorAnimation;
  late final Animation<double> widthAnimation;
  late final double maxInnerCircleDiameter;
  late final double minInnerCircleDiameter;

  @override
  void initState() {
    super.initState();

    maxInnerCircleDiameter = widget.switcherHeight * 0.8;
    minInnerCircleDiameter = maxInnerCircleDiameter / 2;

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    colorAnimation =
        ColorTween(begin: widget.disabledColor, end: widget.enabledColor)
            .animate(animationController);
    widthAnimation = Tween<double>(
            begin: maxInnerCircleDiameter, end: minInnerCircleDiameter)
        .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return GestureDetector(
              onTap: !animationController.isAnimating
                  ? () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                    }
                  : null,
              child: Container(
                height: widget.switcherHeight,
                width: widget.switcherWidth,
                decoration: BoxDecoration(
                  color: colorAnimation.value,
                  borderRadius:
                      BorderRadius.circular(widget.switcherHeight / 2),
                  boxShadow: [
                    BoxShadow(
                      color: colorAnimation.value?.withOpacity(0.5) ??
                          Colors.transparent,
                      offset: const Offset(0, 8),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: (widget.switcherHeight / 2 -
                              maxInnerCircleDiameter / 2) +
                          animationController.value *
                              (widget.switcherWidth -
                                  widget.switcherHeight / 2 -
                                  minInnerCircleDiameter / 2 -
                                  5),
                      top: (widget.switcherHeight - maxInnerCircleDiameter) / 2,
                      child: Container(
                        height: maxInnerCircleDiameter,
                        width: widthAnimation.value,
                        decoration: BoxDecoration(
                          color: widget.innerCircleColor,
                          borderRadius: BorderRadius.circular(
                            maxInnerCircleDiameter / 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          height: maxInnerCircleDiameter / 2.5,
                          width: widthAnimation.value /
                              2.5 *
                              (1 - animationController.value).abs(),
                          decoration: BoxDecoration(
                            color: colorAnimation.value,
                            borderRadius: BorderRadius.circular(
                              maxInnerCircleDiameter / 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
