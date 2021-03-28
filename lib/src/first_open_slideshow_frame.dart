import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:first_open_slideshow/dependencies/flare_splash_screen.dart';
import 'package:first_open_slideshow/src/slideshow_page.dart';
import 'package:first_open_slideshow/src/slideshow_page_widget.dart';
import 'package:flutter/material.dart';

const double PAGE_ITEM_ICON_SIZE = 250;

class FirstOpenSlideshowFrame extends StatefulWidget {
  static const String FIRST_RUN_PREF_KEY = "FIRST_RUN_PREF_KEY";
  static String stringForNext = "";
  final List<SlideshowPage> pageItems;
  final VoidCallback finishCallback;
  final Duration? animationDuration;

  FirstOpenSlideshowFrame(
    this.finishCallback, {
    Key? key,
    required this.pageItems,
    required stringForNext,
    this.animationDuration,
  }) {
    FirstOpenSlideshowFrame.stringForNext = stringForNext;
  }

  @override
  _FirstOpenSlideshowFrameState createState() =>
      _FirstOpenSlideshowFrameState();
}

class _FirstOpenSlideshowFrameState extends State<FirstOpenSlideshowFrame> {
  bool showOverlay = false;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageTransitionSwitcher(
            duration: this.widget.animationDuration!,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child);
            },
            child: Container(
              key: ValueKey<int>(this.currentPage),
              child: SlideshowPageWidget.fromSlideshowPage(
                widget.pageItems[currentPage],
                () {
                  if (widget.pageItems[currentPage] == widget.pageItems.last) {
                    finishPage(context);
                  } else {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
              ),
            )),
        showOverlay
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Center(
                  child: Container(
                    width: PAGE_ITEM_ICON_SIZE,
                    height: PAGE_ITEM_ICON_SIZE,
                    child: SplashScreen.callback(
                      name: 'assets/flare/send_success.flr',
                      onSuccess: (_) {
                        widget.finishCallback();
                      },
                      onError: (_, __) {
                        widget.finishCallback();
                      },
                      startAnimation: 'Untitled',
                      until: () => Future.delayed(
                        Duration(seconds: 1),
                      ),
                      endAnimation: '1',
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void finishPage(BuildContext context) async {
    //show animation and finish
    setState(
      () {
        showOverlay = true;
      },
    );
  }
}
