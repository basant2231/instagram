import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key);

  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );

    // Define the scale animation
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start the animation if the isAnimating property changed
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  // Method to start the animation
  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      // Play the animation forward
      await controller.forward();

      // Play the animation in reverse
      await controller.reverse();

      // Add a delay after the animation finishes
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      // Trigger the onEnd callback if provided
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the animation controller
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}

/*When the user double-taps on the post image, the isLikeAnimating variable is set to true using setState(), which triggers a rebuild of the PostCard widget.
Inside the GestureDetector widget, a Stack is used to overlay the post image with the heart animation. The AnimatedOpacity widget is used to control the opacity of the heart animation based on the isLikeAnimating value.
Inside the AnimatedOpacity, the LikeAnimation widget is used. The LikeAnimation widget takes several properties:
isAnimating: This property is set to the value of isLikeAnimating. When isAnimating is true, the heart animation plays.
child: The child of LikeAnimation is an Icon widget representing a heart.
duration: The duration for the animation to play.
onEnd: A callback function that is triggered when the animation ends. In this case, it updates the isLikeAnimating value back to false using setState().
The LikeAnimation widget is also used for the like button, where it is wrapped around the IconButton. The isAnimating property is set to check if the post has been liked by the user.
Overall, the LikeAnimation widget provides a visual animation effect when the post is liked or double-tapped, adding an interactive and engaging element to the user interface*/