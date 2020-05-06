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
                        return EasyPicker.auto(
                          selectChange: (context, indexPath) {
                            if (indexPath.section == 0 && indexPath.row == 0) return ['aaa', 'sss', 'ddd'];
                            if (indexPath.section == 0 && indexPath.row == 2) return ['qqq', 'www', 'eee'];
                            if (indexPath.section == 1 && indexPath.row == 0) return ['zzz', 'xxx', 'ccc'];
                            if (indexPath.section == 2 && indexPath.row == 0) return ['!!!', '@@@', '###'];
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
                    width: 150.0,
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
                        return EasyPicker.auto(
                          selectChange: (context, indexPath) {
                            if (indexPath.section == 0 && indexPath.row == 0) {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['aaa', 'sss', 'ddd']);
                              });
                            }
                            if (indexPath.section == 0 && indexPath.row == 2) {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['qqq', 'www', 'eee']);
                              });
                            }
                            if (indexPath.section == 1 && indexPath.row == 0) {
                              Future.delayed(Duration(seconds: 1), () {
                                EasyPicker.of(context).addNewTitles(['zzz', 'xxx', 'ccc']);
                              });
                            }
                            if (indexPath.section == 2 && indexPath.row == 0) {
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
                      '延时自动加载picker',
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
