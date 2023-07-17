import 'dart:math';

import 'package:flutter/material.dart';

class MenuAnimation extends StatefulWidget {
  const MenuAnimation({super.key, required this.title});
  final String title;

  @override
  State<MenuAnimation> createState() => _MenuAnimationState();
}

class _MenuAnimationState extends State<MenuAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> widthAnimation;
  late final Animation<double> offsetFromCenterAnimation;
  late final Animation<double> angleAnimation;
  late final Animation<double> barWidthAnimation;
  final fakeList = List.generate(4, (index) => index);
  static const maxWidth = 300.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    offsetFromCenterAnimation =
        Tween<double>(begin: 8.0, end: 0).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0,
        0.2,
        curve: Curves.ease,
      ),
    ));
    widthAnimation =
        Tween<double>(begin: 60, end: maxWidth).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.2,
        0.75,
        curve: Curves.ease,
      ),
    ));
    angleAnimation =
        Tween<double>(begin: 0, end: pi / 6).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.75,
        0.9,
        curve: Curves.ease,
      ),
    ));

    barWidthAnimation =
        Tween<double>(begin: 26, end: 20).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.9,
        1.0,
        curve: Curves.ease,
      ),
    ));
  }

  final circleSize = 60.0;
  final barHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: const SizedBox(),
            floatingActionButton: AnimatedBuilder(
                animation: widthAnimation,
                builder: (context, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: circleSize,
                      width: widthAnimation.value,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: !controller.isAnimating
                            ? () {
                                if (controller.isCompleted) {
                                  controller.reverse();
                                } else {
                                  controller.forward();
                                }
                              }
                            : null,
                        child: Stack(
                          children: [
                            Positioned(
                              left: (circleSize - barWidthAnimation.value) / 2 +
                                  barWidthAnimation.value +
                                  20,
                              child: SizedBox(
                                height: circleSize,
                                width: maxWidth -
                                    (circleSize - barWidthAnimation.value) / 2 +
                                    barWidthAnimation.value +
                                    10,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      opacity: controller.value < 0.5
                                          ? 0
                                          : controller.value,
                                      child: Container(
                                        height: circleSize - 10,
                                        width: circleSize - 10,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: (1.3 *
                                                  controller.value *
                                                  (circleSize - 10))
                                              .clamp(0, circleSize - 10),
                                          width: (1.3 *
                                                  controller.value *
                                                  (circleSize - 10))
                                              .clamp(0, circleSize - 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: 14,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                            Positioned(
                              top: circleSize / 2 -
                                  barHeight / 2 -
                                  offsetFromCenterAnimation.value,
                              left: (circleSize - barWidthAnimation.value) / 2,
                              child: Transform.rotate(
                                angle: angleAnimation.value,
                                origin: Offset(barWidthAnimation.value / 2, 0),
                                child: Container(
                                  height: barHeight,
                                  width: barWidthAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: circleSize / 2 -
                                  barHeight / 2 -
                                  offsetFromCenterAnimation.value,
                              left: (circleSize - barWidthAnimation.value) / 2,
                              child: Transform.rotate(
                                angle: -angleAnimation.value,
                                origin: Offset(barWidthAnimation.value / 2, 0),
                                child: Container(
                                  height: barHeight,
                                  width: barWidthAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}