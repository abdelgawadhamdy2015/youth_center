import 'package:flutter/material.dart';

class GroupsDisplayCard extends StatelessWidget {
  const GroupsDisplayCard({
    super.key,
    required this.title,
    required this.groups,
    required this.groupCardBuilder,
    this.spacing = 12.0,
    this.runSpacingFactor = 0.01,
    this.horizontalSpacingFactor = 0.1,
  });

  final String title;
  final List<List<String>> groups;
  final Widget Function(int index, List<String> group) groupCardBuilder;
  final double spacing;
  final double runSpacingFactor;
  final double horizontalSpacingFactor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: spacing),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: screenWidth * horizontalSpacingFactor,
              runSpacing: screenWidth * runSpacingFactor,
              children: groups
                  .asMap()
                  .entries
                  .map((entry) => groupCardBuilder(entry.key, entry.value))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
