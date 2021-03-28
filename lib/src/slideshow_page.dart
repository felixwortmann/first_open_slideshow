import 'package:first_open_slideshow/src/first_open_slideshow_frame.dart';
import 'package:flutter/material.dart';

/// Represents one page of the [Slideshow]
class SlideshowPage {
  /// Title of the SlideshowPage
  final String titleText;

  /// Text for the caption
  /// (one of [captionText] and [captionWidget] has to be filled. Also only one can be filled)
  final String? captionText;

  /// Text for the Button (Button is only showed when != null and notEmpty)
  final String? buttonText;

  /// Icon for the [SlideshowPage]
  final Widget? icon;

  /// Widget for the caption
  /// (one of [captionText] and [captionWidget] has to be filled. Also only one can be filled)
  final Widget? captionWidget;

  /// Defines if the Title is centered in in the AppBar
  final bool? centerTitle;

  /// Defines Widget for the bottom, usually is something minor like a privacy policy link
  final Widget? bottomWidget;

  /// Color of the text on the button
  final Color? nextButtonTextColor;

  SlideshowPage(
      {required this.titleText,
      this.icon,
      this.buttonText,
      this.captionText,
      this.centerTitle,
      this.captionWidget,
      this.nextButtonTextColor,
      this.bottomWidget})

      /// Caption Text or Caption Widget are required only one can be provided
      : assert((captionWidget != null || captionText != null) &&
            !(captionText != null && captionWidget != null));
}

class SlideshowPageIconContainer extends StatelessWidget {
  final Widget? icon;

  const SlideshowPageIconContainer(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: PAGE_ITEM_ICON_SIZE,
        width: PAGE_ITEM_ICON_SIZE,
        child: this.icon,
      );
}

class SlideshowPageText extends StatelessWidget {
  final String? text;
  final Color? color;

  SlideshowPageText(this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text!,
      style: TextStyle(fontSize: 20, color: color),
    );
  }
}
