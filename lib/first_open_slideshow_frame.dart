import 'dart:ui';
import 'package:first_open_slideshow/slideshow_item_widget.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';

class FirstOpenSlideshowFrame extends StatefulWidget {
  static const String FIRST_RUN_PREF_KEY = "FIRST_RUN_PREF_KEY";
  static String stringForNext = "";
  final List<PageItem> pageItems;
  final VoidCallback finishCallback;
  FirstOpenSlideshowFrame(
    this.finishCallback, {
    Key key,
    @required this.pageItems,
    @required stringForNext,
  }) {
    FirstOpenSlideshowFrame.stringForNext = stringForNext;
  }

  @override
  _FirstOpenSlideshowFrameState createState() => _FirstOpenSlideshowFrameState();
}

class _FirstOpenSlideshowFrameState extends State<FirstOpenSlideshowFrame> {
  bool showOverlay = false;
  PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: widget.pageItems
                .map(
                  (pageItem) => PageItemWidget.fromPageItem(
                    pageItem,
                    () {
                      if (pageItem == widget.pageItems.last) {
                        finishPage(context);
                      } else {
                        goToNextPage();
                      }
                    },
                  ),
                )
                .toList(),
          ),
          showOverlay
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 250,
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
      ),
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

  void goToNextPage() {
    setState(() {
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}

class PageItem {
  final String titleText;
  final String captionText;
  final String buttonText;
  final Widget icon;
  final Widget captionWidget;
  final bool centerTitle;

  ///Caption Text or Caption Widget are required
  PageItem(
      {@required this.titleText,
      this.icon,
      this.buttonText,
      this.captionText,
      this.centerTitle,
      this.captionWidget});
}

class PageIconContainer extends StatelessWidget {
  final Widget icon;

  const PageIconContainer(this.icon, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      child: this.icon,
    );
  }
}

class PageText extends StatelessWidget {
  final String text;

  PageText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(fontSize: 20),
    );
  }
}
