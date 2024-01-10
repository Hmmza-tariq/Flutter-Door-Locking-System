import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class HomeController extends GetxController {
  bool showDoorUnlocked = true;
  bool iOpenedDoor = false;
  bool fromCamera = false;
  bool intruderAlert = false;
  int counter = 10;
  String url = 'http://192.168.43.131/1024x768.jpg';
  List<int> ids = [365214, 367455, 368711, 392541];
  @override
  void onInit() {
    super.onInit();

    loop();
    loop_1();
    loop_2();
  }

  void loop() async {
    Future.delayed(const Duration(seconds: 1), () async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot_1 = await ref.child('FINGERPRINT/ENTERED').get();
      bool unlock = false;
      for (int id in ids) {
        final snapshot_2 = await ref.child('Students/$id').get();
        if (snapshot_2.exists) {
          unlock = true;
          fromCamera = true;
          break;
        }
      }
      if (snapshot_1.exists || unlock) {
        showDoorUnlocked = true;
      } else {
        showDoorUnlocked = false;
        // print('No data available.');
      }
      update();
      loop();
    });
  }

  void loop_1() async {
    if (iOpenedDoor) {
      showDoorUnlocked = true;
      update();
      Future.delayed(const Duration(seconds: 5), () async {
        showDoorUnlocked = false;
        iOpenedDoor = false;
        update();
      });
    }
    loop_1();
  }

  void loop_2() async {
    Future.delayed(const Duration(seconds: 1), () async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot_3 = await ref.child('INTRUDER').get();
      if (snapshot_3.exists) {
        intruderAlert = true;
        update();
        timer();
        update();
        timerCounter();
        update();
      }

      loop_2();
    });
  }

  void deleteNode() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot_3 = await ref.child('INTRUDER').get();
    if (snapshot_3.exists) {
      ref.child('INTRUDER').remove();
      intruderAlert = false;
      counter = 10;
    }
    update();
  }

  void callOnWhatsapp() async {
    print('callOnWhatsapp');

    const link = WhatsAppUnilink(
      phoneNumber: '++923404279353',
      text: 'Intruder Alert!!!',
    );
    await launchUrl(Uri.parse(link.toString()));
  }

  void timer() async {
    Future.delayed(const Duration(seconds: 20), () async {
      callOnWhatsapp();
      deleteNode();
      update();
    });
  }

  void timerCounter() {
    Future.delayed(const Duration(seconds: 1), () async {
      if (counter <= 0) {
        counter--;
        update();
        timerCounter();
      }
    });
  }

  Widget onSupplySwitch() {
    return FirebaseAnimatedList(
        defaultChild: const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
        reverse: true,
        shrinkWrap: true,
        query: FirebaseDatabase.instance.ref("from_app"),
        itemBuilder: (context, snapshot, animation, index) {
          return SwitchListTile(
            activeColor: const Color.fromARGB(255, 255, 255, 255),
            activeTrackColor:
                const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            title: const Center(
              child: Text(
                'Open Door Automatically',
                style: TextStyle(color: Colors.white),
              ),
            ),
            value: snapshot.value.toString() == 'ON' ? true : false,
            onChanged: (bool value) {
              FirebaseDatabase.instance
                  .ref("from_app")
                  .child('open_door')
                  .set(value == true ? "ON" : "OFF");
              iOpenedDoor = value;
              update();
            },
          );
        });
  }
}
