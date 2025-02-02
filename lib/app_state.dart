import 'package:flutter/material.dart';
import 'teme.dart';

class AppState with ChangeNotifier {
  double fontSize = 22.0;
  double iconSize = 24.0;
  String fontFamily = 'Roboto-Regular';
  Color bodyColor = Colors.white;
  Color primaryColor = Colors.black;
  Color textColor = Colors.black;
  Color primaryText = Colors.white;
  int currentThemeIndex = 0;
  bool highlightLinksActive = false;
  bool underlineLinksActive = false;

  Tema odabranaTema = Tema(primary: Colors.grey, body: Colors.white, text: Colors.black, ime: "početna");

  List<Tema> teme = [
    Tema(primary: Colors.black, primaryText: Colors.white, body: Colors.white, text: Colors.black, ime: "početna"),
    Tema(primary: const Color.fromARGB(255, 26, 69, 113), primaryText: const Color.fromARGB(255, 254, 255, 38), body: const Color.fromARGB(255, 26, 69, 113), text: const Color.fromARGB(255, 254, 255, 38), ime: "plavo-žuta"),
    Tema(primary: const Color.fromARGB(255, 112, 158, 68), primaryText: Colors.black, body: const Color.fromARGB(255, 112, 158, 68), text: Colors.black, ime: "zeleno-crna"),
    Tema(primary: const Color.fromARGB(255, 199, 46, 43), primaryText: Colors.black, body: const Color.fromARGB(255, 199, 46, 43), text: Colors.black),
    Tema(primary: Colors.black, primaryText: const Color.fromARGB(255, 254, 255, 38), body: Colors.black, text: const Color.fromARGB(255, 254, 255, 38), ime: "crno-žuta"),
    Tema(primary: Colors.white, primaryText: Colors.black, body: Colors.black, text: Colors.white, ime: "dark-mode")
  ];

  void toggleFont() {
    if (fontFamily == 'Roboto-Regular') {
      fontFamily = 'OpenDyslexic-Regular';
    } else {
      fontFamily = 'Roboto-Regular';
    }
    notifyListeners();
  }

  void increaseSize() {
    fontSize += 2.0;
    iconSize += 2.0;
    notifyListeners();
  }

  void decreaseSize() {
    if (fontSize > 10.0 && iconSize > 16.0) {
      fontSize -= 2.0;
      iconSize -= 2.0;
      notifyListeners();
    }
  }

  void resetSize() {
    fontSize = 22.0;
    iconSize = 24.0;
    fontFamily = 'Roboto-Regular';
    changeTheme(0);
    underlineLinksActive = false;
    highlightLinksActive = false;
    notifyListeners();
  }

  void selectTheme(Tema tema){
    if(tema == teme[0]) changeTheme(0);
    if(tema == teme[1]) changeTheme(1);
    if(tema == teme[2]) changeTheme(2);
    if(tema == teme[3]) changeTheme(3);

    odabranaTema = tema;
    notifyListeners();
  }

  void changeTheme(index) async {
    primaryColor = teme[index].primary!;
    bodyColor = teme[index].body!;
    textColor = teme[index].text!;
    notifyListeners();
  }

  void cycleTheme(){
    if (currentThemeIndex == 3){
      currentThemeIndex = 0;
    } else {
      currentThemeIndex = (currentThemeIndex + 1) % teme.length;
    }
    selectTheme(teme[currentThemeIndex]);
  }

  void setDarkMode() {
    changeTheme(4);
    notifyListeners();
  }

  void highlightLinks() {
    highlightLinksActive = true;
    underlineLinksActive = false;
    notifyListeners();
  }

  void underlineLinks() {
    underlineLinksActive = true;
    highlightLinksActive = false;
    notifyListeners();
  }

}
