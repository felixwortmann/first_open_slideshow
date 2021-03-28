import 'package:first_open_slideshow/src/first_open_slideshow_frame.dart';
import 'package:first_open_slideshow/src/slideshow_page.dart';
import 'package:flutter/material.dart';

const bool _DEFAULT_SCROLLABLE_VALUE = true;

/// Docs for attributes are in [SlideshowPage]
class SlideshowPageWidget extends StatelessWidget {
  final String titleText;
  final String? captionText;
  final String? buttonText;
  final Widget? icon;
  final Widget? captionWidget;
  final VoidCallback? nextPressed;
  final bool? centerTitle;
  final bool scrollable;
  final Widget? bottomWidget;
  final Color? nextButtonTextColor;

  ///caption Text or Caption Widget are Required
  const SlideshowPageWidget(
      {Key? key,
      required this.titleText,
      this.icon,
      this.captionText,
      this.captionWidget,
      this.nextPressed,
      this.centerTitle,
      this.scrollable = _DEFAULT_SCROLLABLE_VALUE,
      this.buttonText,
      this.bottomWidget,
      this.nextButtonTextColor})
      : super(key: key);

  static SlideshowPageWidget fromSlideshowPage(
          final SlideshowPage slideshowPage, final VoidCallback nextPressed,
          {final bool scrollable = _DEFAULT_SCROLLABLE_VALUE}) =>
      SlideshowPageWidget(
        titleText: slideshowPage.titleText,
        captionText: slideshowPage.captionText,
        icon: slideshowPage.icon,
        captionWidget: slideshowPage.captionWidget,
        nextPressed: nextPressed,
        buttonText: slideshowPage.buttonText,
        centerTitle: slideshowPage.centerTitle,
        scrollable: scrollable,
        bottomWidget: slideshowPage.bottomWidget,
        nextButtonTextColor: slideshowPage.nextButtonTextColor,
      );

  @override
  Widget build(BuildContext context) {
    Widget? captionWidget = this.captionWidget;
    if (captionText != null) {
      captionWidget = Padding(
        padding: const EdgeInsets.all(16.0),
        child: SlideshowPageText(captionText),
      );
    }
    return Material(
      child: scrollable
          ? Scaffold(
              appBar: AppBar(
                centerTitle: this.centerTitle ?? true,
                title: Text(
                  titleText,
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: scrollableBody(context, captionWidget),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: contentWidgets(captionWidget),
            ),
    );
  }

  List<Widget> scrollableBody(context, captionWidget) => [
        Expanded(
          child: ListView(children: contentWidgets(captionWidget)),
        ),
        nextPressed != null
            ? Padding(
                padding: EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: double.infinity, minHeight: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => nextPressed!(),
                    child: Text(
                      buttonText ?? FirstOpenSlideshowFrame.stringForNext,
                      style:
                          TextStyle(fontSize: 16, color: nextButtonTextColor),
                    ),
                  ),
                ),
              )
            : Container(),
      ];

  List<Widget> contentWidgets(captionWidget) =>
      [
        icon != null
            ? Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 100),
                child: SlideshowPageIconContainer(
                  icon,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: captionWidget,
          ),
        ),
      ] +
      [bottomWidget ?? Offstage()];
}
