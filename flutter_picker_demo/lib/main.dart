import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'easy_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: PickerDemo(),
    );
  }
}

class PickerDemo extends StatefulWidget {
  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> {
  List<String> selectList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('EasyPicker'),
          ),
          body: Container(
            color: Color.fromARGB(255, 240, 240, 240),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((BuildContext context) {
                        return EasyPicker(
                          pickerHeight: 150.0,
                          initialTitlesList: [
                            ['111', '222', '333'],
                            ['aaa', 'bbb', 'ccc']
                          ],
                          initialIndex: 0,
                          confirm: (selects) {
                            setState(() => selectList = selects);
                          },
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    width: 100.0,
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text(
                      '普通picker',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((BuildContext context) {
                        return EasyPicker(
                          pickerHeight: 150.0,
                          selectChange: (context, text, indexPath) {
                            if (text == '11111') return ['aaa', 'sss', 'ddd'];
                            if (text == '3333333') return ['qqq', 'www', 'eee'];
                            if (text == 'qqq') return ['zzz', 'xxx', 'ccc'];
                            if (text == 'zzz') return ['!!!', '@@@', '###'];
                            return null;
                          },
                          initialTitles: [
                            '11111',
                            '222222',
                            '3333333',
                            '4444444',
                            '55555555',
                            '66666666',
                            '77777777'
                          ],
                          initialIndex: 0,
                          confirm: (selects) {
                            setState(() => selectList = selects);
                          },
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    width: 120.0,
                    height: 50.0,
                    margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                    alignment: Alignment.center,
                    child: Text(
                      '自动加载picker',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: ((BuildContext context) {
                        return EasyPicker(
                          pickerHeight: 150.0,
                          selectChange: (context, text, indexPath) {
                            print(text);
                            if (text == '11111') {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['aaa', 'sss', 'ddd']);
                              });
                            }
                            if (text == '3333333') {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['qqq', 'www', 'eee']);
                              });
                            }
                            if (text == 'qqq') {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['zzz', 'xxx', 'ccc']);
                              });
                            }
                            if (text == 'zzz') {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['!!!', '@@@', '###']);
                              });
                            }
                            return null;
                          },
                          initialTitles: [
                            '11111',
                            '222222',
                            '3333333',
                            '4444444',
                            '55555555',
                            '66666666',
                            '77777777'
                          ],
                          initialIndex: 0,
                          confirm: (selects) {
                            setState(() => selectList = selects);
                          },
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                    ),
                    width: 140.0,
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text(
                      '自动加载延时picker',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                  ),
                  width: 200.0,
                  margin: EdgeInsets.only(top: 30.0),
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  child: Text(
                    selectList.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
