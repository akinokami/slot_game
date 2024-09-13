import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slot_game/services/local_storage.dart';
import 'package:slot_game/slot_machine/roll_slot.dart';
import 'package:slot_game/slot_machine/roll_slot_controller.dart';
import 'package:slot_game/utils/assets.dart';
import 'package:slot_game/utils/color_const.dart';
import 'package:slot_game/views/screens/settings/setting_screen.dart';
import 'package:slot_game/views/widgets/custom_card.dart';
import 'package:slot_game/views/widgets/custom_text.dart';

import '../../../utils/dimen_const.dart';
import '../../../utils/enum.dart';
import '../../widgets/custom_game_button.dart';

class SlotGameScreen extends StatefulWidget {
  const SlotGameScreen({Key? key}) : super(key: key);

  @override
  State<SlotGameScreen> createState() => _SlotGameScreenState();
}

class _SlotGameScreenState extends State<SlotGameScreen> {
  List<int> values = List.generate(100, (index) => index);

  final _rollSlotController = RollSlotController(secondsBeforeStop: 10);
  final _rollSlotController1 = RollSlotController(secondsBeforeStop: 10);
  final _rollSlotController2 = RollSlotController(secondsBeforeStop: 10);
  final random = Random();
  final List<String> prizesList = [
    Assets.seven,
    Assets.soccer,
    Assets.football,
    Assets.snooker,
    Assets.volleyvall,
    Assets.tennis,
    Assets.basketball,
    Assets.baseball,
  ];

  num balance = 0;
  int slot1 = -1;
  int slot2 = -1;
  int slot3 = -1;
  num betAmount = 500;
  bool selected500 = true;
  bool selected1000 = false;
  bool selected2000 = false;
  bool selected3000 = false;
  bool selected5000 = false;

  @override
  void initState() {
    balance = LocalStorage.instance.read(StorageKey.balance.name) ?? 0;
    _rollSlotController.addListener(() {
      if (_rollSlotController.state == RollSlotControllerState.stopped) {
        print("_rollSlotController");
        print(_rollSlotController.centerIndex);
        slot1 = _rollSlotController.centerIndex;
      }
      setState(() {});
    });
    _rollSlotController1.addListener(() {
      if (_rollSlotController1.state == RollSlotControllerState.stopped) {
        print("_rollSlotController1");
        print(_rollSlotController1.centerIndex);
        slot2 = _rollSlotController1.centerIndex;
      }

      setState(() {});
    });
    _rollSlotController2.addListener(() {
      if (_rollSlotController2.state == RollSlotControllerState.stopped) {
        print("_rollSlotController2");
        print(_rollSlotController2.centerIndex);
        slot3 = _rollSlotController2.centerIndex;
        calculateBalance();
      }

      setState(() {});
    });
    super.initState();
  }

  void calculateBalance() {
    if (slot1 == 7 && slot2 == 7 && slot3 == 7) {
      balance += betAmount * 1.5;
    } else if (slot1 == 6 && slot2 == 6 && slot3 == 6) {
      balance += betAmount * 2;
    } else if (slot1 == 5 && slot2 == 5 && slot3 == 5) {
      balance += betAmount * 2.5;
    } else if (slot1 == 4 && slot2 == 4 && slot3 == 4) {
      balance += betAmount * 3;
    } else if (slot1 == 3 && slot2 == 3 && slot3 == 3) {
      balance += betAmount * 3.5;
    } else if (slot1 == 2 && slot2 == 2 && slot3 == 2) {
      balance += betAmount * 4;
    } else if (slot1 == 1 && slot2 == 1 && slot3 == 1) {
      balance += betAmount * 5;
    } else if (slot1 == 0 && slot2 == 0 && slot3 == 0) {
      balance += betAmount * 21;
    } else if (slot1 == 0 || slot2 == 0 || slot3 == 0) {
      balance += betAmount * 5;
    } else if (slot1 == 0 && slot2 == 0 ||
        slot1 == 0 && slot3 == 0 ||
        slot2 == 0 && slot3 == 0) {
      balance += betAmount * 7;
    }
    LocalStorage.instance.write(StorageKey.balance.name, balance);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/bg.webp",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomGameButton(
                      onTap: () {
                        Get.back();
                      },
                      height: 35.w,
                      width: 35.w,
                      icon: Icons.arrow_back,
                      iconColor: Colors.white,
                    ),
                    CustomGameButton(
                      onTap: () {
                        Get.to(() => const SettingScreen());
                      },
                      height: 35.w,
                      width: 35.w,
                      icon: Icons.settings,
                      iconColor: Colors.white,
                    ),
                  ],
                ),
                kSizedBoxH10,
                CustomCard(
                  color: bgColor,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'your_balance'.tr),
                      CustomText(
                        text: balance.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomCard(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RollSlotWidget(
                          prizesList: prizesList,
                          rollSlotController: _rollSlotController,
                        ),
                        RollSlotWidget(
                          prizesList: prizesList,
                          rollSlotController: _rollSlotController1,
                        ),
                        RollSlotWidget(
                          prizesList: prizesList,
                          rollSlotController: _rollSlotController2,
                        ),
                        // RollSlotWidget(
                        //   prizesList: prizesList,
                        //   rollSlotController: _rollSlotController3,
                        // ),
                      ],
                    ),
                  ),
                ),
                CustomCard(
                    widget: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected500 = true;
                              selected1000 = false;
                              selected2000 = false;
                              selected3000 = false;
                              selected5000 = false;
                              betAmount = 500;
                            });
                          },
                          child: Container(
                            width: 50.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: selected500 ? green : greyTicket,
                                borderRadius: BorderRadius.circular(5.r)),
                            alignment: Alignment.center,
                            child: const CustomText(text: '500'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected500 = false;
                              selected1000 = true;
                              selected2000 = false;
                              selected3000 = false;
                              selected5000 = false;
                              betAmount = 1000;
                            });
                          },
                          child: Container(
                            width: 50.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: selected1000 ? green : greyTicket,
                                borderRadius: BorderRadius.circular(5.r)),
                            alignment: Alignment.center,
                            child: const CustomText(text: '1000'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected500 = false;
                              selected1000 = false;
                              selected2000 = true;
                              selected3000 = false;
                              selected5000 = false;
                              betAmount = 2000;
                            });
                          },
                          child: Container(
                            width: 50.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: selected2000 ? green : greyTicket,
                                borderRadius: BorderRadius.circular(5.r)),
                            alignment: Alignment.center,
                            child: const CustomText(text: '2000'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected500 = false;
                              selected1000 = false;
                              selected2000 = false;
                              selected3000 = true;
                              selected5000 = false;
                              betAmount = 3000;
                            });
                          },
                          child: Container(
                            width: 50.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: selected3000 ? green : greyTicket,
                                borderRadius: BorderRadius.circular(5.r)),
                            alignment: Alignment.center,
                            child: const CustomText(text: '3000'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected500 = false;
                              selected1000 = false;
                              selected2000 = false;
                              selected3000 = false;
                              selected5000 = true;
                              betAmount = 5000;
                            });
                          },
                          child: Container(
                            width: 50.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                                color: selected5000 ? green : greyTicket,
                                borderRadius: BorderRadius.circular(5.r)),
                            alignment: Alignment.center,
                            child: const CustomText(text: '5000'),
                          ),
                        ),
                      ],
                    ),
                    kSizedBoxH10,
                    CustomGameButton(
                      onTap: () {
                        balance -= betAmount;
                        final index = prizesList.length - 1;
                        _rollSlotController.animateRandomly(
                            topIndex: Random().nextInt(index),
                            centerIndex: Random().nextInt(index),
                            bottomIndex: Random().nextInt(index));
                        _rollSlotController1.animateRandomly(
                            topIndex: Random().nextInt(index),
                            centerIndex: Random().nextInt(index),
                            bottomIndex: Random().nextInt(index));
                        _rollSlotController2.animateRandomly(
                            topIndex: Random().nextInt(index),
                            centerIndex: Random().nextInt(index),
                            bottomIndex: Random().nextInt(index));

                        Future.delayed(const Duration(seconds: 2), () {
                          _rollSlotController.stop();
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          _rollSlotController1.stop();
                        });
                        Future.delayed(const Duration(seconds: 4), () {
                          _rollSlotController2.stop();
                        });
                      },
                      width: 0.2.sh,
                      text: 'play'.tr,
                      textColor: Colors.white,
                    ),
                  ],
                )),
                kSizedBoxH10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RollSlotWidget extends StatelessWidget {
  final List<String> prizesList;

  final RollSlotController rollSlotController;

  const RollSlotWidget(
      {Key? key, required this.prizesList, required this.rollSlotController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: RollSlot(
                itemExtend: 115,
                rollSlotController: rollSlotController,
                children: prizesList.map(
                  (e) {
                    return BuildItem(
                      asset: e,
                    );
                  },
                ).toList()),
          ),
          Flexible(
            child: TextButton(
              onPressed: null,
              child: CustomText(text: ''.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildItem extends StatelessWidget {
  const BuildItem({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        asset,
        width: 45.w,
      ),
    );
  }
}
