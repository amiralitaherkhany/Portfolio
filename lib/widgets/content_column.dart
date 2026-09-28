import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

/// Centres a content column and caps its width.
///
/// On a large monitor an uncapped column stretches until it hugs both edges,
/// which makes long paragraphs hard to read and leaves the middle of the page
/// looking empty. This keeps the measure comfortable and the block centred.
class ContentColumn extends StatelessWidget {
  const ContentColumn({super.key, required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? context.tokens.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
