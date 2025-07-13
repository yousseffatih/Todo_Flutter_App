import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titlestyle,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 14,
              ),
              margin: const EdgeInsets.only(top: 8),
              width: SizeConfig.screenWidth,
              height: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey)),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    readOnly: widget != null ? true : false,
                    style: subTitlestyle,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitlestyle,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.scaffoldBackgroundColor,
                              width: 0)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.scaffoldBackgroundColor,
                              width: 0)),
                    ),
                  )),
                  widget ?? Container(),
                ],
              ),
            ),
          ],
        ));
  }
}
