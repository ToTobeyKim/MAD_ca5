import 'package:flutter/material.dart';
import 'dart:async';

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
  Image myImage = Image.network(
    'https://static.vecteezy.com/system/resources/previews/001/199/181/original/emoji-cat-face-neutral-png.png',
    width: 300,
    height: 300,
  );
  String happinessState = "Neutral";
  Timer? hungerTimer;
  Timer? winTimer;
  int happinessDuration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      askPetName();
    });

    // Start the timer for increasing hunger every 30 seconds
    hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100); // Hunger increases over time
        CheckHappinessColor();
        lossCondition();
        checkWinCondition(); // Check win condition periodically
      });
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      CheckHappinessColor();
      lossCondition();
      checkWinCondition();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      lossCondition();
      _updateHappiness();
      CheckHappinessColor();
      checkWinCondition();
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

  // Check happiness and change background color
  void CheckHappinessColor() {
    if (happinessLevel > 70) {
      x = Colors.green;
      myImage = Image.network(
        'https://static-00.iconduck.com/assets.00/smiling-cat-face-with-open-mouth-emoji-2048x2048-i1lhgbn1.png',
        width: 300,
        height: 300,
      );
      happinessState = "Happy";
    } else if (happinessLevel >= 30) {
      x = Colors.yellow;
      myImage = Image.network(
        'https://static.vecteezy.com/system/resources/previews/001/199/181/original/emoji-cat-face-neutral-png.png',
        width: 300,
        height: 300,
      );
      happinessState = "Neutral";
    } else {
      x = Colors.red;
      myImage = Image.network(
        'https://static-00.iconduck.com/assets.00/crying-cat-face-emoji-512x436-ba1f5eto.png',
        width: 300,
        height: 300,
      );
      happinessState = "Sad";
    }
  }

  void askPetName() {
    TextEditingController nameController = TextEditingController();

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          petName = nameController.text.isNotEmpty ? nameController.text : "Your Pet";
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Enter Your Pet's Name"),
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(hintText: "Pet Name"),
      ),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Loss condition if happiness <= 10 and hunger == 100
  void lossCondition() {
    if (happinessLevel <= 10 && hungerLevel == 100) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text("Your pet has been neglected and is very unhappy!"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void checkWinCondition() {
    if (happinessLevel > 80) {
      if (winTimer == null) {
        winTimer = Timer.periodic(Duration(seconds: 180), (timer) {
          happinessDuration++;
          if (happinessDuration >= 3) {
            showWinDialog();
            timer.cancel();
            winTimer = null; 
          }
        });
      }
    } else {
      happinessDuration = 0; // Reset if happiness drops below 80
      winTimer?.cancel();
      winTimer = null;
    }
  }

  // Show win dialog when the player wins
  void showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win!"),
          content: Text("You Win!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
