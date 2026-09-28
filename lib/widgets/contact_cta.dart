import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/link_constants.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/utils/open_url.dart';
import 'package:my_portfolio/widgets/app_button.dart';

/// Closing call to action.
///
/// The most important addition to the page: a visitor who likes what they see
/// now has an obvious next step.
class ContactCta extends StatelessWidget {
  const ContactCta({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final links = availableLinks;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.gutter,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.tokens.cardRadius),
        gradient: LinearGradient(
          colors: <Color>[
            colors.primary.withValues(alpha: 0.18),
            colors.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                PersonalInfo.contactHeadline,
                textAlign: TextAlign.center,
                style: context.texts.headlineMedium,
              ),
              const SizedBox(height: 14),
              Text(
                PersonalInfo.contactSubhead,
                textAlign: TextAlign.center,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.mutedText,
                ),
              ),
              const SizedBox(height: 28),
              if (links.isEmpty)
                Text(
                  'Add your contact links in lib/constants/link_constants.dart.',
                  textAlign: TextAlign.center,
                  style: context.texts.bodySmall?.copyWith(
                    color: context.mutedText,
                  ),
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 14,
                  children: <Widget>[
                    for (final link in links)
                      AppButton(
                        label: link.name,
                        leading: FaIcon(link.icon, size: 18),
                        variant: link == links.first
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outline,
                        onPressed: () => openLink(link),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
