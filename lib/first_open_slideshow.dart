library first_open_slideshow;

import 'package:first_open_slideshow/first_open_slideshow_frame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slideshow extends StatefulWidget {
  final Widget whenFinished;
  final Widget loadingPage;
  final List<PageItem> slideShowItems;
  final String stringForNext;
  final Duration animationDuration;

  const Slideshow({
    Key key,
    @required this.whenFinished,
    @required this.slideShowItems,
    @required this.stringForNext,
    this.animationDuration = const Duration(milliseconds: 300),
    this.loadingPage,
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
          finishedShowing =
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
      print("finished");
      return this.widget.whenFinished;
    }
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
