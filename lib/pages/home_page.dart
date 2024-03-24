import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/color_utils.dart';
import '../helpers/dialog_utils.dart';
import '../helpers/my_list_tile.dart';
import '../helpers/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyListTile> _myListTile = [];
  final apiCaller = ApiCaller();

  @override
  void initState() {
    super.initState();
    _loadMyListTile();
  }

  Future<void> _loadMyListTile() async {
    try {
      final data = await apiCaller.get("web_types");
      List list = jsonDecode(data);
      setState(() {
        _myListTile = list.map((e) => MyListTile.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    Color primaryColor = generateRandomColor();
    Color darkenedColor = darken(primaryColor, 30);
    Color lightenedColor = lighten(primaryColor, 90);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkenedColor,
        title: Container(
          child: Text(
            'Webby Fondue',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              'ระบบรายงานเว็บเลว ๆ',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
          preferredSize: Size.fromHeight(15.0),
        ),
      ),
      body: Container(
        color: lightenedColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyTextField(
                controller: TextEditingController(),
                hintText: 'URL *',
              ),
              const SizedBox(height: 8.0),
              MyTextField(
                controller: TextEditingController(),
                hintText: 'รายละเอียด',
              ),
              const SizedBox(height: 15.0),
              Text('ระบุประเภทเว็บเลว *', style: textTheme.titleMedium),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _myListTile.length,
                  itemBuilder: (context, index) {
                    final item = _myListTile[index];
                    return GestureDetector(
                      child: MyListTile(
                        id: item.id,
                        title: item.title,
                        subtitle: item.subtitle,
                        imageUrl:
                            'https://cpsu-api-49b593d4e146.herokuapp.com/' +
                                item.imageUrl,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _handleApiPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkenedColor,
                ),
                child: const Text(
                  'ส่งข้อมูล',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "todos",
        params: {
          "id": 1,
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      Map map = jsonDecode(data);
      String text =
          'ขอบคุณสำหรับการแจ้งข้อมูล รหัสข้อมูลของคุณคือ ${map['id']}\n\n สถิติการรายงาน\n=====\n}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(
        context: context,
        title: "Error",
        message: "ต้องกรอก URL และเลือกประเภทเว็บ",
      );
    }
  }
  
  Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
