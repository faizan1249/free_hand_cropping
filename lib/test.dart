class MagnifierInkWell extends StatefulWidget {
  final Widget child;

  const MagnifierInkWell({Key key, this.child}) : super(key: key);

  @override
  _MagnifierInkWellState createState() => _MagnifierInkWellState();
}

class _MagnifierInkWellState extends State<MagnifierInkWell> {
  Offset _magnifierPosition;
  bool _isMagnifying = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isMagnifying)
          Positioned(
            left: _magnifierPosition.dx - 100,
            top: _magnifierPosition.dy - 100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Transform.scale(
                  scale: 2,
                  child: widget.child,
                ),
              ),
            ),
          ),
      ],
    );
  }
} 






MagnifierInkWell(
  child: CustomPaint(
    painter: CropPainter(
      points: _points,
    ),
    child: Image.asset('image.jpg'),
  ),
)