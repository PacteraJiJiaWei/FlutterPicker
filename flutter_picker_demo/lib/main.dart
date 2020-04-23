import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'easy_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: PickerDemo(),
        ),
      ),
    );
  }
}

class PickerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: ((BuildContext context) {
            return EasyPicker(
              pickerHeight: 150.0,
              selectChange: (text, indexPath) {
                if (text == '11111') return ['aaa', 'sss', 'ddd'];
                if (text == '3333333') return ['qqq', 'www', 'eee'];
                if (text == 'qqq') return ['zzz', 'xxx', 'ccc'];
                if (text == 'zzz') return ['!!!', '@@@', '###'];
                return null;
              },
              initialTitles: ['11111', '222222', '3333333', '4444444', '55555555', '66666666', '77777777'],
              initialIndex: 0,
              confirm: (selects) {
                print(selects);
              },
            );
          }),
        );
      },
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}
