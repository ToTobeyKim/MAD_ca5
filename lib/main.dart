import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
    theme: ThemeData(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color x = Colors.yellow;
  Image myImage = Image.network('https://static.vecteezy.com/system/resources/previews/001/199/181/original/emoji-cat-face-neutral-png.png', 
  width: 300,
  height: 300);
  String happinessState = "Neutral";

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      CheckHappinessColor();  // Check color after updating happiness
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      CheckHappinessColor();  // Check color after updating happiness
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }



  // Check happiness and change background color
  void CheckHappinessColor() {
    if (happinessLevel > 70) {
      x = Colors.green;
      myImage = Image.network('https://static-00.iconduck.com/assets.00/smiling-cat-face-with-open-mouth-emoji-2048x2048-i1lhgbn1.png',
      width: 300,
      height: 300);
      happinessState = "Happy";
    } else if (happinessLevel >= 30) {
      x = Colors.yellow;
      myImage = Image.network('https://static.vecteezy.com/system/resources/previews/001/199/181/original/emoji-cat-face-neutral-png.png',
      width: 300,
      height: 300);
      happinessState = "Neutral";
    } else {
      x = Colors.red;
      myImage = Image.network('https://static-00.iconduck.com/assets.00/crying-cat-face-emoji-512x436-ba1f5eto.png',
      width: 300,
      height: 300);
      happinessState = "Sad";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: x,
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            myImage,
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Happiness State: $happinessState',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}