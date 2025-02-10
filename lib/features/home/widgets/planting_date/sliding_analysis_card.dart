import 'package:flutter/material.dart';
import 'analysis_result_card.dart';

class SlidingAnalysisCard extends StatefulWidget {
  final String result;

  const SlidingAnalysisCard({
    super.key,
    required this.result,
  });

  @override
  State<SlidingAnalysisCard> createState() => _SlidingAnalysisCardState();
}

class _SlidingAnalysisCardState extends State<SlidingAnalysisCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = true;
  double _dragExtent = 0;
  final double _dragThreshold = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (_isVisible) {
        _dragExtent =
            (_dragExtent + details.delta.dx).clamp(-_dragThreshold, 0);
      } else {
        _dragExtent = (_dragExtent + details.delta.dx).clamp(0, _dragThreshold);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final extent = _dragExtent.abs();

    if (extent >= _dragThreshold / 2 || velocity.abs() > 200) {
      if ((_isVisible && _dragExtent < 0) || (!_isVisible && _dragExtent > 0)) {
        _toggleVisibility();
      }
    }

    setState(() {
      _dragExtent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dragProgress = _dragExtent / _dragThreshold;
    final cardOffset = _isVisible ? dragProgress : (dragProgress - 1.0);

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            final slideValue = _slideAnimation.value.dx + cardOffset;
            return Transform.translate(
              offset: Offset(MediaQuery.of(context).size.width * slideValue, 0),
              child: child,
            );
          },
          child: Row(
            children: [
              Expanded(
                child: AnalysisResultCard(result: widget.result),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggleVisibility,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: Container(
              width: 28,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    final progress = _isVisible
                        ? (1 - _slideAnimation.value.dx - dragProgress)
                        : (-_slideAnimation.value.dx - dragProgress + 1);
                    return Transform.rotate(
                      angle: progress * 3.14159,
                      child: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
