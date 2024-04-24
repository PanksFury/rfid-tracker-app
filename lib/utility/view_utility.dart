import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewUtility {
  static Widget networkImageEdit(String url, double height, double width) {
    return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
              height: height,
              width: width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: height,
                  color: Colors.grey.shade300,
                  width: double.infinity,
                ),
              ),
              // Center(
              //   child: CircularProgressIndicator(),
              // ),
            ),
        // Center(
        //       child: Text("...."),
        //     ),
        errorWidget: (context, url, error) => const Icon(Icons.error));
  }

  static Widget networkImage(String url, double height, double width,
      {double opacity = 1, double borderRadius = 15.0}) {
    return Opacity(
      opacity: opacity,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: height,
          width: width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              height: height,
              color: Colors.grey.shade300,
              width: double.infinity,
            ),
          ),
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
        ),
        errorWidget: (context, url, error) => Card(
          color: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  static Widget networkImageScaledown(String url, double height, double width) {
    return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.scaleDown,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
              height: height,
              width: width,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    height: height,
                    color: Colors.grey,
                    width: double.infinity,
                  ),
                ),
              ),
              // Center(
              //   child: CircularProgressIndicator(),
              // ),
            ),
        errorWidget: (context, url, error) => const Icon(Icons.error));
  }

  static Widget networkImageTextInitial(String url, double height, double width,
      {double opacity = 1, double borderRadius = 15.0, required String title}) {
    return Opacity(
      opacity: opacity,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: height,
          width: width,
          child: Card(
            color: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              height: height,
              color: Colors.transparent,
              width: width,
            ),
          ),
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
        ),
        errorWidget: (context, url, error) => Card(
          color: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: textInitialView(borderRadius, title),
        ),
      ),
    );
  }

  static textInitialView(double size, String name) {
    return CircleAvatar(
      radius: (size / 2),
      backgroundColor: Colors.white,
      //backgroundColor: RMBConstant.theme_color,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Text(
            getInitial(name),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (size / 2),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  static getInitial(String name) {
    var initial = name.isNotEmpty
        ? name
            .trim()
            .split(RegExp(' +'))
            .map((s) => s[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';

    return initial;
  }

  static String toTitleCase(String str) {
    return str.trim().toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
}
