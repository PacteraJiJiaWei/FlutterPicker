import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'base_picker.dart';

typedef BaseAutoPickerSelectChange = List<String> Function(
    BuildContext context, String text, PickerIndexPath indexPath);
typedef BaseAutoPickerConfirm = Function(List<String> titles);

// ignore: must_be_immutable
class EasyPicker extends StatefulWidget {
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
  List<String> initialTitles;

  /// 所有文言数据
  List<List<String>> initialTitlesList;

  /// 异步加载数据
  bool async;

  /// 选中改变时的回调
  final BaseAutoPickerSelectChange selectChange;

  /// 默认选中第一行第几个
  final int initialIndex;

  /// 默认选中每一行第几个
  final List<int> initialIndexList;

  /// 点击完成时的回调
  final BaseAutoPickerConfirm confirm;

  EasyPicker({
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
    this.initialTitlesList,
    this.selectChange,
    this.initialIndex,
    this.initialIndexList,
    this.confirm,
    this.async = false,
  }) : assert(initialTitles == null || initialTitlesList == null, 'initialTitles属性和initialTitlesList属性只能存在一个！');

  @override
  _EasyPickerState createState() => _EasyPickerState();

  /// 用来获取当前的state
  static _EasyPickerState of(BuildContext context) {
    return context.findAncestorStateOfType<_EasyPickerState>();
  }
}

class _EasyPickerState extends State<EasyPicker> with TickerProviderStateMixin {
  /// 用来设置动画效果
  AnimationController controller;
  Animation<Offset> animation;
  bool isAnimation = false;
  bool firstLoad = true;
  BuildContext currentContext;

  /// 记录数据
  List<PickerModel> models = List();
  int currentSection = 0;

  @override
  void initState() {
    super.initState();

    /// 只初始化一列，其余的自动加载
    if (widget.initialTitles != null) {
      PickerModel model = PickerModel(itemTitles: widget.initialTitles, currentIndex: widget.initialIndex ?? 0);
      models.add(model);
    } else {
      /// 默认全部加载
      widget.initialTitlesList.map((titles) {
        int index = widget.initialTitlesList.indexOf(titles);
        PickerModel model = PickerModel(
            itemTitles: titles, currentIndex: widget.initialIndexList != null ? widget.initialIndexList[index] : 0);
        models.add(model);
      }).toList();
    }
  }

  /// 延迟加载数据
  addNewTitles(List<String> newTitles) {
    PickerModel model = PickerModel(itemTitles: newTitles, currentIndex: 0);
    setState(() => models.add(model));
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      _reloadModels(currentContext, models.length-1, 0);
    });
  }

  /// 自动获取数据流
  _reloadModels(BuildContext context, int section, int row) {
    List<String> newTitles = widget.selectChange(
        context,
        models[section].itemTitles[row],
        PickerIndexPath(
          section: section,
          row: row,
        ));
    List<PickerModel> tempModels = List();

    // 更新展示数据列表
    if (models.length >= section + 1) {
      models.getRange(0, section + 1).map((model) {
        tempModels.add(model);
      }).toList();
      setState(() => models = tempModels);
    }
    if (newTitles != null) {
      PickerModel model = PickerModel(itemTitles: newTitles, currentIndex: 0);
      tempModels.add(model);
      setState(() => models = tempModels);
      _reloadModels(context, section + 1, 0);
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
      controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
      animation =
          Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 1 - (widget.headerHeight + widget.pickerHeight) / height))
              .animate(controller);
      controller.forward();
    }

    return Builder(
      builder: (context) {
        currentContext = context;
        /// 首次自动加载下一项
        if (widget.initialTitles != null && firstLoad) {
          firstLoad = false;
          Future.delayed(Duration.zero, () {
            _reloadModels(context, 0, widget.initialIndex ?? 0);
          });
        }
        return Material(
          color: Colors.transparent,
          child: Container(
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
                          print(model.currentIndex);
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
                              models[section].currentIndex = row;
                              if (widget.selectChange != null && widget.initialTitles != null) {
                                _reloadModels(context, section, row);
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
          ),
        );
      },
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
