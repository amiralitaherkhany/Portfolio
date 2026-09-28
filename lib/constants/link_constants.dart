import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Social and contact links.
///
/// The header, footer and contact section all iterate this list, so adding a
/// link here automatically adds it everywhere.

enum LinkConstants {
  myEmail(
    'mailto:$kContactEmail',
    'Email',
    FontAwesomeIcons.envelope,
  ),
  myLinkedIn(
    'https://www.linkedin.com/in/amirali-taherkhany-348925299/',
    'LinkedIn',
    FontAwesomeIcons.linkedin,
  ),
  myGithub(
    'https://github.com/amiralitaherkhany',
    'GitHub',
    FontAwesomeIcons.github,
  ),
  myTelegram(
    'https://t.me/amiralyamiralyamiraly',
    'Telegram',
    FontAwesomeIcons.telegram,
  );

  const LinkConstants(this.url, this.name, this.icon);

  final String url;
  final String name;

  /// Must be rendered with [FaIcon] rather than [Icon] to avoid clipping.
  final FaIconData icon;

  /// Entries with a blank URL are filtered out of the UI.
  bool get isAvailable => url.trim().isNotEmpty && !url.endsWith('@');
}

/// Placeholder — set this to your real address.
const String kContactEmail = 'amiralitaherkhany07@gmail.com';

/// Only the links that should actually be rendered.
List<LinkConstants> get availableLinks => LinkConstants.values
    .where((link) => link.isAvailable)
    .toList(growable: false);
