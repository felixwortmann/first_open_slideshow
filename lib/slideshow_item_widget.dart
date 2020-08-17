import 'package:first_open_slideshow/first_open_slideshow_frame.dart';
import 'package:flutter/material.dart';

const bool _DEFAULT_SCROLLABLE_VALUE = true;

class PageItemWidget extends StatelessWidget {
  final String titleText;
  final String captionText;
  final String buttonText;
  final Widget icon;
  final Widget captionWidget;
  final VoidCallback nextPressed;
  final bool centerTitle;
  final bool scrollable;

  ///caption Text or Caption Widget are Required
  const PageItemWidget(
      {Key key,
      @required this.titleText,
      this.icon,
      this.captionText,
      this.captionWidget,
      this.nextPressed,
      this.centerTitle,
      this.scrollable = _DEFAULT_SCROLLABLE_VALUE,
      this.buttonText})
      : super(key: key);

  static PageItemWidget fromPageItem(
          final PageItem pageItem, final VoidCallback nextPressed,
          {final bool scrollable = _DEFAULT_SCROLLABLE_VALUE}) =>
      PageItemWidget(
        titleText: pageItem.titleText,
        captionText: pageItem.captionText,
        icon: pageItem.icon,
        captionWidget: pageItem.captionWidget,
        nextPressed: nextPressed,
        buttonText: pageItem.buttonText,
        centerTitle: pageItem.centerTitle,
        scrollable: scrollable,
      );

  @override
  Widget build(BuildContext context) {
    Widget captionWidget = this.captionWidget;
    if (captionText != null) {
      captionWidget = Padding(
        padding: const EdgeInsets.all(16.0),
        child: PageText(captionText),
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
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: double.infinity, minHeight: 50),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () => nextPressed(),
                    child: Text(
                      buttonText ?? FirstOpenSlideshowFrame.stringForNext,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            : Container(),
      ];

  List<Widget> contentWidgets(captionWidget) => [
        icon != null
            ? Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 100),
                child: PageIconContainer(
                  icon,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
                child: captionWidget,
              ) ??
              Container(),
        ),
      ];
}
