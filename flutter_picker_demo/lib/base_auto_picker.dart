import 'package:flutter/material.dart';
import 'base_picker.dart';

typedef BaseAutoPickerSelectChange = List<String> Function(String text, PickerIndexPath indexPath);
typedef BaseAutoPickerConfirm = Function(List<String> titles);

class BaseAutoPicker extends StatefulWidget {
  /// 取消文言
  final String cancelText;

  /// 取消文言文字类型
  final TextStyle cancelTextStyle;

  /// 确认文言
  final String confirmText;

  /// 确认文言文字类型
  final TextStyle confirmTextStyle;

  /// 顶部颜色
  final Color headerColor;

  /// picker背景颜色
  final Color pickerColor;

  /// header高度
  final double headerHeight;

  /// picker高度
  final double pickerHeight;

  /// 初始文言数组
  final List<String> initialTitles;

  /// 选中改变时的回调
  final BaseAutoPickerSelectChange selectChange;

  /// 默认选中第一行第几个
  final int initialIndex;

  /// 点击完成时的回调
  final BaseAutoPickerConfirm confirm;

  BaseAutoPicker({
    Key key,
    this.cancelText = '取消',
    this.cancelTextStyle,
    this.confirmText = '确认',
    this.confirmTextStyle,
    this.headerColor = Colors.white,
    this.pickerColor = Colors.white,
    this.headerHeight = 30.0,
    this.pickerHeight = 150.0,
    this.initialTitles,
    this.selectChange,
    this.initialIndex,
    this.confirm,
  });
  @override
  _BaseAutoPickerState createState() => _BaseAutoPickerState();
}

class _BaseAutoPickerState extends State<BaseAutoPicker> with TickerProviderStateMixin {
  /// 用来设置动画效果
  AnimationController controller;
  Animation<Offset> animation;
  bool isAnimation = false;

  /// 记录数据
  List<PickerModel> models = List();
  int currentSection = 0;

  @override
  void initState() {
    super.initState();
    PickerModel model = PickerModel(itemTitles: widget.initialTitles, currentIndex: widget.initialIndex ?? 0);
    models.add(model);
    _reloadModels(0, widget.initialIndex ?? 0);
  }

  /// 延迟加载数据
  addNewTitles(List<String> newTitles) {
    PickerModel model = PickerModel(itemTitles: newTitles, currentIndex: 0);
    setState(() {
      models.add(model);
    });
  }

  /// 获取数据流
  _reloadModels(int section, int row) {
    List<String> newTitles = widget.selectChange(models[section].itemTitles[row], PickerIndexPath(section: section, row: row,));
    List<PickerModel> tempModels = List();
    if (models.length >= section+1) {
      models.getRange(0, section+1).map((model){
        tempModels.add(model);
      }).toList();
    }
    if (newTitles != null) {
      PickerModel model = PickerModel(itemTitles: newTitles, currentIndex: 0);
      tempModels.add(model);
      setState(() {
        models = tempModels;
      });
      _reloadModels(section+1, 0);
    } else {
      setState(() {
        models = tempModels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前屏幕宽高
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // 设置动画
    if (!isAnimation) {
      isAnimation = true;
      controller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
      animation = Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 1-(widget.headerHeight+widget.pickerHeight)/height)).animate(controller);
      controller.forward();
    }

    return Container(
      child: SlideTransition(
        position: animation,
        child: Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              // 顶部视图
              Container(
                height: widget.headerHeight,
                color: widget.headerColor,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // 设置取消按钮
                    GestureDetector(
                      onTap: () {
                        // 点击了取消按钮
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.cancelText,
                        style: widget.cancelTextStyle ??
                            TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                      ),
                    ),
                    // 设置确认按钮
                    GestureDetector(
                      onTap: () {
                        // 点击了确认按钮
                        Navigator.pop(context);
                        List<String> selects = List();
                        models.map((model) {
                          selects.add(model.itemTitles[model.currentIndex]);
                        }).toList();
                        if (widget.confirm != null) widget.confirm(selects);
                      },
                      child: Text(
                        widget.confirmText,
                        style: widget.confirmTextStyle ??
                            TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // picker视图
              Container(
                height: widget.pickerHeight,
                color: widget.pickerColor,
                child: Row(
                  children: models.map((model) {
                    int section = models.indexOf(model);
                    return BasePicker(
                      initialIndex: model.currentIndex,
                      height: widget.pickerHeight,
                      width: width / models.length,
                      itemCount: model.itemTitles.length,
                      color: widget.pickerColor,
                      itemExtent: 40.0,
                      itemBuilder: (index) {
                        return Text(
                          model.itemTitles[index],
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        );
                      },
                      itemChanged: (row) {
                        if (widget.selectChange != null) {
                          models[section].currentIndex = row;
                          _reloadModels(section, row);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickerModel {
  List<String> itemTitles;
  int currentIndex;

  PickerModel({
    Key key,
    this.itemTitles,
    this.currentIndex,
  });
}


class PickerIndexPath {
  int section;
  int row;

  PickerIndexPath({
    Key key,
    this.section,
    this.row,
  });
}