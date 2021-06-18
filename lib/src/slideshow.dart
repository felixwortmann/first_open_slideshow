library first_open_slideshow;

import 'package:first_open_slideshow/src/first_open_slideshow_frame.dart';
import 'package:first_open_slideshow/src/slideshow_page.dart';
import 'package:first_open_slideshow/src/slideshow_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slideshow extends StatefulWidget {
  /// Defines the Widget that is shown when the [Slideshow] is finished
  /// This usually is the main page you want to show permanently
  final Widget whenFinished;

  /// Defines a custom LoadingPage - when null this shows a [CircularProgressIndicator]
  /// Is used when [SharedPreferences] are loaded
  final Widget? loadingPage;

  /// Pages for your Slideshow
  final List<SlideshowPage> slideShowItems;

  /// String for the next Button
  final String stringForNext;

  /// Duration for the Transition Animation
  final Duration animationDuration;

  /// Defines if the [Slideshow] shows the Widgets in a List
  final bool listViewInsteadOfSlideshow;

  /// Can be used to override the shared preferences and always show the [Slideshow]
  /// Default to false
  final bool overrideAlwaysShowSlideshow;

  const Slideshow({
    Key? key,
    required this.whenFinished,
    required this.slideShowItems,
    required this.stringForNext,
    this.animationDuration = const Duration(milliseconds: 300),
    this.loadingPage,
    this.listViewInsteadOfSlideshow = false,
    this.overrideAlwaysShowSlideshow = false,
  }) : super(key: key);

  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  bool finishedShowing = false;
  bool loading = true;

  @override
  void initState() {
    if (loading) {
      SharedPreferences.getInstance().then((prefs) {
        setState(() {
          loading = false;
          finishedShowing = widget.overrideAlwaysShowSlideshow ||
              !(prefs.getBool(FirstOpenSlideshowFrame.FIRST_RUN_PREF_KEY) ??
                  true);
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return this.widget.loadingPage ??
          Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
    }

    if (finishedShowing) {
      return this.widget.whenFinished;
    }
    if (this.widget.listViewInsteadOfSlideshow) {
      return ListView(
        children: this
            .widget
            .slideShowItems
            .map(
              (final SlideshowPage pageItem) =>
                  SlideshowPageWidget.fromSlideshowPage(pageItem, () => {},
                      scrollable: false),
            )
            .toList(),
      );
    } else {
      return FirstOpenSlideshowFrame(
        () {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool(FirstOpenSlideshowFrame.FIRST_RUN_PREF_KEY, false);
          });
          setState(() => finishedShowing = true);
        },
        pageItems: this.widget.slideShowItems,
        stringForNext: this.widget.stringForNext,
        animationDuration: this.widget.animationDuration,
      );
    }
  }
}
