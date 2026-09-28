import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/link_constants.dart';
import 'package:my_portfolio/utils/open_url.dart';
import 'package:my_portfolio/widgets/lighted_icon_button.dart';

/// The social / contact icon row.
///
/// Shared by the header and the footer, which previously each had their own
/// copy of this loop.
class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({super.key, this.spacing = 8, this.iconSize = 19});

  final double spacing;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final links = availableLinks;
    if (links.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final link in links)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: LightedIconButton(
              icon: link.icon,
              tooltip: link.name,
              size: iconSize,
              onClick: () => openLink(link),
            ),
          ),
      ],
    );
  }
}
