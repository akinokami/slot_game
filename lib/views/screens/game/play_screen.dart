import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slot_game/utils/color_const.dart';
import 'package:slot_game/views/screens/game/slot_game_screen.dart';
import 'package:slot_game/views/widgets/custom_game_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controller/sound_controller.dart';
import '../../../services/local_storage.dart';
import '../../../utils/enum.dart';
import '../../../utils/global.dart';
import '../../widgets/custom_text.dart';
import '../settings/setting_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isAccepted = false;
  bool isChecked = false;
  String first = '';
  int selectedGame = 4;

  @override
  void initState() {
    super.initState();
    if (LocalStorage.instance.read(StorageKey.balance.name) == null) {
      LocalStorage.instance.write(StorageKey.balance.name, 50000);
    }

    first = LocalStorage.instance.read(StorageKey.first.name) ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (first == '') {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => Builder(builder: (context) {
                return StatefulBuilder(
                  builder: (context, StateSetter setState) {
                    return AlertDialog(
                      surfaceTintColor: whiteColor,
                      backgroundColor: whiteColor,
                      content: SizedBox(
                        height: 1.sh * 0.80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SingleChildScrollView(
                              child: SizedBox(
                                  height: 1.sh * 0.65,
                                  width: double.infinity,
                                  child: WebViewWidget(
                                      controller: WebViewController()
                                        ..loadHtmlString(
                                            Global.language == Language.vi.name
                                                ? Global.policyVi
                                                : Global.language ==
                                                        Language.hi.name
                                                    ? Global.policyHi
                                                    : Global.policyEn))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  activeColor: secondaryColor,
                                  side: BorderSide(
                                    width: 1.5,
                                    color: isChecked
                                        ? secondaryColor
                                        : Colors.black,
                                  ),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                      if (isChecked) {
                                        isAccepted = true;
                                      } else {
                                        isAccepted = false;
                                      }
                                    });
                                  },
                                ),
                                CustomText(
                                  text: 'agree'.tr,
                                  color: secondaryColor,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          isAccepted
                                              ? secondaryColor
                                              : greyColor)),
                              // ignore: sort_child_properties_last
                              child: CustomText(
                                text: "accept".tr,
                                color: whiteColor,
                                fontSize: 12,
                              ),
                              onPressed: isAccepted
                                  ? () async {
                                      LocalStorage.instance.write(
                                          StorageKey.first.name, 'notfirst');
                                      Navigator.pop(context);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            );
          }
        }
      } catch (e) {
        // print("Error fetching SharedPreferences: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundController = Get.put(SoundController());
    soundController.playSound();

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
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomGameButton(
                      onTap: () {
                        exit(0);
                      },
                      height: 35.w,
                      width: 35.w,
                      icon: Icons.close,
                      iconColor: Colors.white,
                      color1: Colors.red,
                      color2: Colors.red.shade300,
                      color3: Colors.red,
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
                SizedBox(
                  height: 120.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    'assets/logo.webp',
                    width: 100.h,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                CustomGameButton(
                  onTap: () {
                    Get.to(() => const SlotGameScreen());
                  },
                  width: 0.2.sh,
                  text: 'play'.tr,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
