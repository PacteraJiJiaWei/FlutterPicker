import 'package:flutter/material.dart';

typedef BasePickerItemBuilder = Function(int index);
typedef BasePickerSelectedItemChanged = Function(int index);

class BasePicker extends StatefulWidget {
  /// picker高度
  final double height;

  /// picker宽度
  final double width;

  /// item高度
  final double itemExtent;

  /// item创建回调
  final BasePickerItemBuilder itemBuilder;

  /// item个数
  final int itemCount;

  /// 当前选中item发生改变时的回调
  final BasePickerSelectedItemChanged itemChanged;

  /// picker背景颜色
  final Color color;

  /// 初始index
  final int initialIndex;

  BasePicker({
    Key key,
    this.height,
    this.width,
    this.itemExtent = 50.0,
    this.itemBuilder,
    this.itemCount,
    this.itemChanged,
    this.color = Colors.white,
    this.initialIndex = 0,
  });

  @override
  _BasePickerState createState() => _BasePickerState();
}

class _BasePickerState extends State<BasePicker> {
  /// 用来控制手指滑动结束后list的位置
  FixedExtentScrollController controller;

  /// 创建遮盖层
  Widget _buildCoverScreen() {
    if (widget.color != null && widget.color.alpha < 255) return Container();
    final Color widgetBackgroundColor = widget.color ?? const Color(0xFFFFFFFF);
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                widgetBackgroundColor,
                widgetBackgroundColor.withAlpha(0xF2),
                widgetBackgroundColor.withAlpha(0xDD),
                widgetBackgroundColor.withAlpha(0),
                widgetBackgroundColor.withAlpha(0),
                widgetBackgroundColor.withAlpha(0xDD),
                widgetBackgroundColor.withAlpha(0xF2),
                widgetBackgroundColor,
              ],
              stops: const <double>[
                0.0,
                0.05,
                0.09,
                0.22,
                0.78,
                0.91,
                0.95,
                1.0,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: widget.color?.withAlpha((widget.color.alpha * 0.7).toInt()),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.0, color: Color(0xFF7F7F7F)),
                    bottom: BorderSide(width: 0.0, color: Color(0xFF7F7F7F)),
                  ),
                ),
                constraints: BoxConstraints.expand(
                  height: widget.itemExtent,
                  width: widget.width,
                ),
              ),
              Expanded(
                child: Container(
                  color: widget.color?.withAlpha((widget.color.alpha * 0.7).toInt()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: widget.height,
          width: widget.width,
          child: ListWheelScrollView.useDelegate(
            // 可以自动校正list滚动结束后的位置
            controller: controller,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: widget.itemExtent,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Container(
                  color: widget.color,
                  height: widget.itemExtent,
                  alignment: Alignment.center,
                  child: widget.itemBuilder(index),
                );
              },
              childCount: widget.itemCount,
            ),
            onSelectedItemChanged: (index) {
              print(index);
              if (widget.itemChanged != null) widget.itemChanged(index);
            },
          ),
        ),
        _buildCoverScreen(),
      ],
    );
  }
}
