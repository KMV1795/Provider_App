import 'package:flutter/material.dart';
import '../Utils/colors.dart';

class PositionedContainer extends StatelessWidget {
  const PositionedContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -30,
      child: Container(
        height: 150,
        width: 150,
        decoration: const BoxDecoration(
          color: circle,
          borderRadius: BorderRadius.all(Radius.circular(200)),
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 50,
        width: 150,
        margin: const EdgeInsets.only(top: 80),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: titleBox,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: textColor, fontSize: 25, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback callback;
  final String actionName;
  const ActionButton(
      {Key? key, required this.callback, required this.actionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: actionBox,
            maximumSize: const Size(280, 60),
          ),
          onPressed: callback,
          child: Center(
            child: Text(
              actionName,
              style: const TextStyle(color: textColor, fontSize: 25),
            ),
          ),
        ));
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 320,
        margin: const EdgeInsets.only(left: 15, right: 15),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background.jpg")),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback callback;
  const LogoutButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 02, bottom: 05),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: callback,
          child: const Text(
            "Logout",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

Widget inputName(String name) {
  return Text(
    name,
    style: const TextStyle(
        color: textColor, fontWeight: FontWeight.normal, fontSize: 20),
  );
}
