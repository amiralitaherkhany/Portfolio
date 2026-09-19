import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/dark_colors.dart';
import 'package:my_portfolio/widgets/gradiant_text.dart';
import 'package:my_portfolio/widgets/my_avatar.dart';

class MyInformation extends StatelessWidget {
  const MyInformation({super.key});

  @override
  Widget build(BuildContext context) {
    switch (context.width) {
      case >= 1500:
        return SliverToBoxAdapter(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NameAndInfoSection(),
              Spacer(),
              MyAvatar(),
            ],
          ),
        );
      default:
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              MyAvatar(),
              SizedBox(
                height: 50,
              ),
              NameAndInfoSection(),
            ],
          ),
        );
    }
  }
}

class NameAndInfoSection extends StatelessWidget {
  const NameAndInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.percentageOfWidth(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Amirali ",
              style: TextStyle(
                fontSize: 52,
                color: DarkColors.headerTextColor,
              ),
              children: [
                TextSpan(
                  text: "Taherkhany",
                  style: TextStyle(
                    fontSize: 52,
                    color: DarkColors.headerTextColor,
                  ),
                ),
              ],
            ),
          ),
          GradiantText(
            "Software Developer",
            style: TextStyle(
              fontSize: 30,
              color: DarkColors.myWhite,
              fontWeight: FontWeight.bold,
            ),
            colors: [
              Color(0xFF7F7FD5),
              Color(0xFF86A8E7),
              Color(0xFF91EAE4),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            """I’m a software developer focused on building modern mobile and backend applications. I work primarily with Flutter, Kotlin, Dart, and Go, with experience in developing scalable APIs and real-world applications. I enjoy turning ideas into practical, well-designed products while continuously improving my technical skills.""",
            style: TextStyle(
              color: Color(0xFFF5F5F5),
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
