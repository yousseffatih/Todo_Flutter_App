import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.paylod}) : super(key: key);
  
  final String paylod;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();

  
}

class _NotificationScreenState extends State<NotificationScreen> {


  String _paylod = "";
  @override
  void initState()
  {
    super.initState();
    _paylod = widget.paylod; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Text(
          _paylod.toString().split("|")[0],
          style: TextStyle(color: Get.isDarkMode? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children:  [
                const SizedBox(height: 20,),
                Text("Hello , youssef" ,
                     style: TextStyle(
                       fontSize: 26,
                       fontWeight: FontWeight.w900,
                       color: Get.isDarkMode? Colors.white : darkGreyClr,
                     ),
                ),
                const SizedBox( height: 10,),
                Text("You have a new reminder" ,
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w300,
                       color: Get.isDarkMode? Colors.grey[100] : darkGreyClr
                     ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: Container(
                padding: const  EdgeInsets.all(30),
                margin: const  EdgeInsets.only(left: 30,right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_format,size: 26,color: Colors.white,),
                          const SizedBox(width: 20,),
                          Text("Text" ,
                                style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Get.isDarkMode? Colors.white:Colors.white,
                                ),
                              ),
                        ],
                      ),
                      const SizedBox( height: 10 ,),
                      Text(_paylod.toString().split("|")[1],
                          style: const TextStyle(color:Colors.white,fontSize: 20)
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          const Icon(Icons.description,size: 26,color: Colors.white,),
                          const SizedBox(width: 20,),
                          Text("Description" ,
                                style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Get.isDarkMode? Colors.white:Colors.white,
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(_paylod.toString().split("|")[2],
                          style: const TextStyle(color:Colors.white,fontSize: 20),
                          textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,size: 26,color: Colors.white,),
                          const SizedBox(width: 20,),
                          Text("Date" ,
                                style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Get.isDarkMode? Colors.white:Colors.white,
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(_paylod.toString().split("|")[3],
                          style: const TextStyle(color:Colors.white,fontSize: 20),                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}
