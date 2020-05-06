import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'base_picker.dart';

typedef BaseAutoPickerSelectChange = List<String> Function(BuildContext context, PickerIndexPath indexPath);
typedef BaseAutoPickerConfirm = Function(List<String> titles);

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

  /// picker的Item的高度
  final double itemExtent;

  /// 初始文言数组
  final List<String> initialTitles;

  /// 所有文言数据
  final List<List<String>> initialTitlesList;

  /// 选中改变时的回调
  final BaseAutoPickerSelectChange selectChange;

  /// 默认选中第一行第几个
  final int initialIndex;

  /// 默认选中每一行第几个
  final List<int> initialIndexList;

  /// 点击完成时的回调
  final BaseAutoPickerConfirm confirm;

  /// 固定数据模式
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
    this.itemExtent = 40.0,
    List<List<String>> initialTitlesList,
    this.selectChange,
    this.initialIndex = 0,
    this.initialIndexList,
    this.confirm,
  })  : this.initialTitles = null,
        this.initialTitlesList = initialTitlesList;

  /// 自动加载数据模式
  EasyPicker.auto({
    Key key,
    this.cancelText = '取消',
    this.cancelTextStyle,
    this.confirmText = '确认',
    this.confirmTextStyle,
    this.headerColor = Colors.white,
    this.pickerColor = Colors.white,
    this.headerHeight = 30.0,
    this.pickerHeight = 150.0,
    this.itemExtent = 40.0,
    List<String> initialTitles,
    this.selectChange,
    this.initialIndex = 0,
    this.initialIndexList,
    this.confirm,
  })  : this.initialTitles = initialTitles,
        this.initialTitlesList = null;

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
  PickerIndexPath currentIndexPath = PickerIndexPath(section: -1, row: -1);

  @override
  void initState() {
    super.initState();

    /// 只初始化一列，其余的自动加载
    if (widget.initialTitles != null) {
      PickerModel model = PickerModel(itemTitles: widget.initialTitles, currentIndex: widget.initialIndex ?? 0);
      models.add(model);
      Future.delayed(Duration.zero, () {
        _reloadModels(currentContext, PickerIndexPath(section: 0, row: widget.initialIndex ?? 0));
      });
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
      _reloadModels(currentContext, PickerIndexPath(section: models.length - 1, row: 0));
    });
  }

  /// 自动获取数据流
  _reloadModels(BuildContext context, PickerIndexPath indexPath) {
    if (currentIndexPath.section == indexPath.section && currentIndexPath.row == indexPath.row) return;
    currentIndexPath = indexPath;
    List<String> newTitles = widget.selectChange(context, indexPath);
    List<PickerModel> tempModels = List();

    // 更新展示数据列表
    if (models.length >= indexPath.section + 1) {
      // 使用map防止类型不对报错
      models.getRange(0, indexPath.section + 1).map((model) {
        tempModels.add(model);
      }).toList();
      setState(() => models = tempModels);
    }
    if (newTitles != null) {
      PickerModel model = PickerModel(itemTitles: newTitles, currentIndex: 0);
      tempModels.add(model);
      setState(() => models = tempModels);
      _reloadModels(context, PickerIndexPath(section: indexPath.section + 1, row: 0));
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
        // 保存当前context，方便外部获取state
        currentContext = context;
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
                          return BasePicker(
                            initialIndex: model.currentIndex,
                            height: widget.pickerHeight,
                            width: width / models.length,
                            itemCount: model.itemTitles.length,
                            color: widget.pickerColor,
                            itemExtent: widget.itemExtent,
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
                                _reloadModels(context, PickerIndexPath(section: section, row: row));
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
