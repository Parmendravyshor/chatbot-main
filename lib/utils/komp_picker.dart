import 'package:flutter/material.dart';

Future<Null> pickProfileImage(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false,
    // user must tap button!
    builder: (BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      actions: <Widget>[
        IconButton(
          splashColor: Colors.green,
          icon: Icon(
            Icons.cancel,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        )
      ],
      content: Container(
        // Specify some width
        width: MediaQuery.of(context).size.width * .8,
        child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: <String>[
              'assets/profile/profile_1.png',
              'assets/profile/profile_2.png',
              'assets/profile/profile_3.png',
              'assets/profile/profile_4.png',
              'assets/profile/profile_5.png',
              'assets/profile/profile_6.png',
              'assets/profile/profile_7.png',
              'assets/profile/profile_8.png',
            ].map(
              (String path) {
                return GridTile(
                  child: GestureDetector(
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: 120.0,
                      height: 120.0,
                    ),
                    onTap: () {
                      Navigator.pop(context, path);
                    },
                  ),
                );
              },
            ).toList()),
      ),
    ),
  );
}
