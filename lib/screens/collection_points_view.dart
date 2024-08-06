import 'package:flutter/material.dart';

class CollectionPointsView extends StatefulWidget {
  final List<String> items;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onSort;

  const CollectionPointsView({
    Key? key,
    required this.items,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onSort,
  }) : super(key: key);

  @override
  _CollectionPointsViewState createState() => _CollectionPointsViewState();
}

class _CollectionPointsViewState extends State<CollectionPointsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CollectionPointsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Header.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ), // Semi-transparent background color for text and buttons
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.recycling_rounded),
                  SizedBox(width: 8),
                  Text(
                    'Пункты сбора',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizeTransition(
                    sizeFactor: _fadeAnimation,
                    axisAlignment: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.sort),
                      onPressed: widget.onSort,
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: Icon(widget.isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more),
                      onPressed: widget.onToggleExpanded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: widget.isExpanded ? 1000 : 0.0, // Adjust heights as needed
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/Header.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Text('будет список пунктов, сортировка и так далее'))),
        ),
      ],
    );
  }
}
