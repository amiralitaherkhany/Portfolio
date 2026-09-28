import 'package:flutter/foundation.dart';
import 'package:my_portfolio/constants/link_constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens external URLs in one place so every link in the app behaves the same.
///
/// A failed launch (unknown scheme, popup blocked, no browser) is reported to
/// the console instead of throwing.
Future<void> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !await canLaunchUrl(uri)) {
    debugPrint('Could not launch URL: $url');
    return;
  }

  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object catch (error) {
    debugPrint('Failed to open $url: $error');
  }
}

/// Opens a link from [LinkConstants].
void openLink(LinkConstants link) => openExternalUrl(link.url);
