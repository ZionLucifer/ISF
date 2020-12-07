import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<String> getimage(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: FlatButton(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/img/camera.png',
                          fit: BoxFit.fill,
                        ),
                        Text('Camera')
                      ],
                    ),
                    onPressed: () async {
                      final image = await ImagePicker().getImage(
                          imageQuality: 50, source: ImageSource.camera);
                      Navigator.pop(context, image.path);
                    },
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: FlatButton(
                    child: Column(
                      children: [
                        Image.asset('assets/img/gallery.png', fit: BoxFit.fill),
                        Text('Gallery')
                      ],
                    ),
                    onPressed: () async {
                      final image = await ImagePicker().getImage(
                          imageQuality: 50, source: ImageSource.gallery);
                      Navigator.pop(context, image.path);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
