import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text(
            'Smart Lock',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: const []),
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: controller.showDoorUnlocked || controller.iOpenedDoor
                      ? Center(
                          child: Container(
                            width: Get.width * .7,
                            height: Get.height * .2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Center(
                              child: Text(
                                'Door Unlocked',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            width: Get.width * .7,
                            height: Get.height * .2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Center(
                              child: Text(
                                'Door Locked',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      width: Get.width * .7,
                      height: Get.height * .2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(child: controller.onSupplySwitch())),
                ),
                SizedBox(
                  height: Get.height * .05,
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      width: Get.width * .7,
                      height: Get.height * .1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: !controller.intruderAlert
                          ? controller.showDoorUnlocked ||
                                  controller.iOpenedDoor
                              ? Center(
                                  child: Text(
                                  controller.iOpenedDoor
                                      ? 'Door Unlocked through app'
                                      : controller.fromCamera
                                          ? 'Face Recognized'
                                          : 'Fingerprint Recognized',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ))
                              : null
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Intruder Alert',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                    onPressed: controller.deleteNode,
                                    child: const Text('Ignore')),
                                ElevatedButton(
                                    onPressed: controller.callOnWhatsapp,
                                    child: Text('Call ${controller.counter}'))
                              ],
                            ),
                    )),
                SizedBox(
                  height: Get.height * .05,
                ),
              ],
            );
          }),
    );
  }
}
