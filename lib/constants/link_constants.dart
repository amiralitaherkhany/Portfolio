import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum LinkConstants {
  myLinkedIn(
    "https://www.linkedin.com/in/amirali-taherkhany-348925299/",
    "Linkedin",
    FontAwesomeIcons.linkedin,
  ),
  myGithub(
    "https://github.com/amiralitaherkhany",
    "Github",
    FontAwesomeIcons.github,
  ),
  myTelegram(
    "https://t.me/amiralyamiralyamiraly",
    "Telegram",
    FontAwesomeIcons.telegram,
  );

  const LinkConstants(this.url, this.name, this.icon);
  final String url;
  final String name;
  final FaIconData icon;
}
