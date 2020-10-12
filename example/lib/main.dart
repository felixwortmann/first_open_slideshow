import 'package:first_open_slideshow/first_open_slideshow.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static SlideshowPage slideshowItemExample1(final BuildContext context) =>
      SlideshowPage(
          titleText: "Test1",
          icon: Container(
            width: 200,
            height: 200,
            color: Colors.green,
          ),
          captionWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("This is a caption"),
          ),
          buttonText: "Some button text",
          bottomWidget: Center(child: Text("SomeBottomText")));

  static SlideshowPage slideshowItemExample2(final BuildContext context) =>
      SlideshowPage(
        titleText: "Test2",
        icon: Container(
          width: 200,
          height: 200,
          color: Colors.red,
        ),
        captionWidget: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("This is a caption"),
        ),
        buttonText: "Some button text",
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Slideshow(
        // listViewInsteadOfSlideshow: true,
        stringForNext: "Next",
        slideShowItems: [
          slideshowItemExample1(context),
          slideshowItemExample2(context)
        ],
        whenFinished: Container(),
      ),
    );
  }
}
