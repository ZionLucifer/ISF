import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
const double _twoPi = math.pi * 2.0;
const double _epsilon = .001;
const double _sweep = _twoPi - _epsilon;

class LiquidCircularProgressIndicator extends ProgressIndicator {
  ///The width of the border, if this is set [borderColor] must also be set.
  final double borderWidth;

  ///The color of the border, if this is set [borderWidth] must also be set.
  final Color borderColor;

  ///The widget to show in the center of the progress indicator.
  final Widget center;

  ///The direction the liquid travels.
  final Axis direction;

  LiquidCircularProgressIndicator({
    Key key,
    double value = 0.5,
    Color backgroundColor,
    Animation<Color> valueColor,
    this.borderWidth,
    this.borderColor,
    this.center,
    this.direction = Axis.vertical,
  }) : super(
    key: key,
    value: value,
    backgroundColor: backgroundColor,
    valueColor: valueColor,
  ) {
    if (borderWidth != null && borderColor == null ||
        borderColor != null && borderWidth == null) {
      throw ArgumentError("borderWidth and borderColor should both be set.");
    }
  }

  Color _getBackgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).backgroundColor;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).accentColor;

  @override
  State<StatefulWidget> createState() =>
      _LiquidCircularProgressIndicatorState();
}

class _LiquidCircularProgressIndicatorState
    extends State<LiquidCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CircleClipper(),
      child: CustomPaint(
        painter: _CirclePainter(
          color: widget._getBackgroundColor(context),

        ),
        foregroundPainter: _CircleBorderPainter(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        child: Stack(
          children: [
            Wave(
              value: widget.value,
              color: widget._getValueColor(context),
              direction: widget.direction,

            ),
            if (widget.center != null) Center(child: widget.center),


          ],
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;

  _CirclePainter({@required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawArc(Offset.zero & size, 0, _sweep, false, paint);
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => color != oldDelegate.color;
}

class _CircleBorderPainter extends CustomPainter {
  final Color color;
  final double width;

  _CircleBorderPainter({this.color, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    if (color == null || width == null) {
      return;
    }

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final newSize = Size(size.width - width, size.height - width);
    canvas.drawArc(
        Offset(width / 2, width / 2) & newSize, 0, _sweep, false, borderPaint);
  }

  @override
  bool shouldRepaint(_CircleBorderPainter oldDelegate) =>
      color != oldDelegate.color || width != oldDelegate.width;
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..addArc(Offset.zero & size, 0, _sweep);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class Wave extends StatefulWidget {
  final double value;
  final Color color;
  final Axis direction;

  const Wave({
    Key key,
    @required this.value,
    @required this.color,
    @required this.direction,
  }) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        child: Container(
          color: widget.color,
        ),
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double value;
  final Axis direction;

  _WaveClipper({
    @required this.animationValue,
    @required this.value,
    @required this.direction,
  });

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
      return path;
    }

    Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 20);
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
          waveHeight +
          (size.width * value);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 20);
      final dy = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
          waveHeight +
          (size.height - (size.height * value));
      waveList.add(Offset(i.toDouble(), dy));

    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}





class SelectionUserManaged extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionUserManaged(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SelectionUserManaged.withSampleData() {
    return new SelectionUserManaged(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('Onion', 5000),
      new OrdinalSales('Potato', 3),

    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  SelectionUserManagedState createState() {
    return new SelectionUserManagedState();
  }
}

class SelectionUserManagedState extends State<SelectionUserManaged> {
  final _myState = new charts.UserManagedState<String>();

  @override
  Widget build(BuildContext context) {
    final chart = new charts.BarChart(
      widget.seriesList,
      animate: false, //widget.animate,
      selectionModels: [
        new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            updatedListener: _infoSelectionModelUpdated)
      ],
      // Pass in the state you manage to the chart. This will be used to
      // override the internal chart state.
      userManagedState: _myState,
      // The initial selection can still be optionally added by adding the
      // initial selection behavior.
      behaviors: [
        new charts.InitialSelection(selectedDataConfig: [
          new charts.SeriesDatumConfig<String>('Sales', '2016')
        ])
      ],
    );

    final clearSelection = new MaterialButton(
        onPressed: _handleClearSelection, child: new Text('ID:INV001',style: TextStyle(
        fontFamily: 'JosefinSans')));

    return new Column(
        children: [new SizedBox(child: chart, height: 150.0), clearSelection]);
  }

  void _infoSelectionModelUpdated(charts.SelectionModel<String> model) {
    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    _myState.selectionModels[charts.SelectionModelType.info] =
    new charts.UserManagedSelectionModel(model: model);
  }

  void _handleClearSelection() {
    // Call set state to request a rebuild, to pass in the modified selection.
    // In this case, passing in an empty [UserManagedSelectionModel] creates a
    // no selection model to clear all selection when rebuilt.
    setState(() {
      _myState.selectionModels[charts.SelectionModelType.info] =
      new charts.UserManagedSelectionModel();
    });
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}