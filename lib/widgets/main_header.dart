import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/link_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/dark_colors.dart';
import 'package:my_portfolio/widgets/lighted_icon_button.dart';
import 'package:my_portfolio/widgets/lighted_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: context.percentageOfWidth(6),
        ),
        child: ClipRSuperellipse(
          borderRadius: BorderRadiusGeometry.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          child: Container(
            height: 70,
            decoration: ShapeDecoration(
              color: DarkColors.onBackgroundColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.percentageOfWidth(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      switch (context.width) {
                        case >= 1200:
                          return DesktopView();
                        default:
                          return MobileView();
                      }
                    },
                  ),
                  Spacer(),
                  IconRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  const DesktopView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.percentageOfWidth(5),
      children: [
        for (var headerLink in HeaderLink.values) ...{
          LightedTextButton(
            text: headerLink.name,
            onPressed: () => scrollToSection(headerLink),
          ),
        },
      ],
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: [
        PopupMenuButton<HeaderLink>(
          color: DarkColors.onBackgroundColor,
          icon: FaIcon(
            FontAwesomeIcons.bars,
            color: DarkColors.myGrey,
          ),
          onSelected: (value) => scrollToSection(value),
          itemBuilder: (context) => [
            for (var headerLink in HeaderLink.values) ...{
              PopupMenuItem(
                value: headerLink,
                child: Text(
                  headerLink.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: DarkColors.myGrey,
                  ),
                ),
              ),
            },
          ],
        ),
        if (context.width > 530) ...{
          AnimatedMyName(),
        },
      ],
    );
  }
}

void scrollToSection(HeaderLink headerLink) {
  final context = headerLink.key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(
        milliseconds: 1000,
      ),
      curve: Curves.easeInOut,
    );
  }
}

class AnimatedMyName extends StatefulWidget {
  const AnimatedMyName({
    super.key,
  });

  @override
  State<AnimatedMyName> createState() => _AnimatedMyNameState();
}

class _AnimatedMyNameState extends State<AnimatedMyName>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controler;
  late final Animation _animation;

  @override
  void dispose() {
    _controler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controler = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = TweenSequence(
      [
        TweenSequenceItem(
          tween: ColorTween(
            begin: DarkColors.myWhite,
            end: DarkColors.myGrey,
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: DarkColors.myGrey,
            end: DarkColors.myWhite,
          ),
          weight: 1,
        ),
      ],
    ).animate(_controler);
    _controler.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controler,
      builder: (context, child) {
        return Text(
          "Amirali Taherkhany",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: _animation.value,
          ),
        );
      },
    );
  }
}

class IconRow extends StatelessWidget {
  const IconRow({
    super.key,
  });
  void _launchURL(String url) {
    launchUrl(
      Uri.parse(url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: LinkConstants.values.map<Widget>(
        (e) {
          return LightedIconButton(
            faIcon: e.icon,
            onClick: () {
              _launchURL(e.url);
            },
            color: Colors.grey,
            hoverColor: Colors.white,
            toolTip: e.name,
          );
        },
      ).toList(),
    );
  }
}

class HeaderLink {
  final String name;
  final GlobalKey key;

  const HeaderLink._(this.name, this.key);

  static final skills = HeaderLink._('Skills', GlobalKey());
  static final projects = HeaderLink._('Projects', GlobalKey());

  static final values = [skills, projects];
}
