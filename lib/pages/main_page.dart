import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/experience_constants.dart';
import 'package:my_portfolio/controllers/navigation_controller.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/app_tokens.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/widgets/contact_cta.dart';
import 'package:my_portfolio/widgets/content_column.dart';
import 'package:my_portfolio/widgets/experience_viewer.dart';
import 'package:my_portfolio/widgets/main_footer.dart';
import 'package:my_portfolio/widgets/main_header.dart';
import 'package:my_portfolio/widgets/my_information.dart';
import 'package:my_portfolio/widgets/project_viewer.dart';
import 'package:my_portfolio/widgets/section_divider.dart';
import 'package:my_portfolio/widgets/section_title.dart';
import 'package:my_portfolio/widgets/skill_viewer.dart';
import 'package:particles_network/particles_network.dart';

/// The single-page portfolio: hero, skills, projects, experience, contact and
/// footer, assembled from slivers.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScrollController _scrollController;
  late final NavigationController _navigation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _navigation = NavigationController(
      headerHeight: AppTokens.defaultHeaderHeight,
    );
    _navigation.attach(_scrollController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigation.updateHeaderHeight(context.tokens.headerHeight);

    // The active section is derived from the scroll position, which is only
    // meaningful once the slivers have been laid out. Without this the header
    // would open with nothing highlighted until the first scroll event.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _navigation.updateActive();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _navigation
      ..detach(_scrollController)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() => _navigation.updateActive();

  @override
  Widget build(BuildContext context) {
    final gutter = Breakpoints.gutterFor(context.width);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Decorative background, paused when the tab is hidden.
          ParticleNetwork(
            particleCount: 60,
            maxSpeed: 0.5,
            maxSize: 1.5,
            lineWidth: 1,
            lineDistance: context.width * 0.12 < 100
                ? 100
                : context.width * 0.12,
            particleColor: context.colors.primary,
            lineColor: context.colors.onSurface.withValues(alpha: 0.35),
            touchColor: context.colors.primary,
            touchActivation: false,
            drawNetwork: true,
            fill: false,
            isComplex: false,
          ),
          // Desktop web has no visible scrollbar by default; the page is long
          // enough that one helps.
          Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                MainHeader(navigation: _navigation),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(gutter, 56, gutter, 0),
                  sliver: SliverToBoxAdapter(
                    child: ContentColumn(
                      child: MyInformation(navigation: _navigation),
                    ),
                  ),
                ),
                ..._buildSkills(gutter),
                ..._buildProjects(),
                if (kShowExperienceSection) ..._buildExperience(gutter),
                ..._buildContact(gutter),
                // Breathing room so the contact panel does not butt straight up
                // against the footer, which is a distinct surface.
                SliverToBoxAdapter(
                  child: SizedBox(height: context.tokens.sectionGap),
                ),
                SliverToBoxAdapter(
                  child: MainFooter(scrollController: _scrollController),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSkills(double gutter) => <Widget>[
    _sectionHeader(
      AppSection.skills,
      'Skills',
      subtitle:
          'The tools I reach for most often, from mobile UI to backend and '
          'delivery.',
    ),
    SliverPadding(
      padding: EdgeInsets.fromLTRB(gutter, 36, gutter, 0),
      sliver: const SliverToBoxAdapter(
        child: ContentColumn(child: SkillViewer()),
      ),
    ),
  ];

  /// Full-bleed: the carousel spans the screen width, so it is intentionally
  /// not wrapped in a gutter or a capped column.
  List<Widget> _buildProjects() => <Widget>[
    _sectionHeader(
      AppSection.projects,
      'Projects',
      subtitle: 'A few things I have designed, built and shipped.',
    ),
    const SliverToBoxAdapter(child: ProjectViewer()),
  ];

  List<Widget> _buildExperience(double gutter) => <Widget>[
    _sectionHeader(
      AppSection.experience,
      'Experience',
      subtitle: 'Where I have worked and what I have been building.',
    ),
    SliverPadding(
      padding: EdgeInsets.fromLTRB(gutter, 36, gutter, 0),
      sliver: const SliverToBoxAdapter(
        child: ContentColumn(child: ExperienceViewer()),
      ),
    ),
  ];

  List<Widget> _buildContact(double gutter) => <Widget>[
    _sectionHeader(AppSection.contact, 'Contact'),
    SliverPadding(
      padding: EdgeInsets.fromLTRB(gutter, 32, gutter, 0),
      sliver: const SliverToBoxAdapter(
        child: ContentColumn(child: ContactCta()),
      ),
    ),
  ];

  /// Divider plus heading, carrying the key used as a scroll target.
  Widget _sectionHeader(
    AppSection section,
    String title, {
    String? subtitle,
  }) {
    return SliverToBoxAdapter(
      key: _navigation.keyFor(section),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: <Widget>[
            const SectionDivider(),
            SectionTitle(title: title, subtitle: subtitle),
          ],
        ),
      ),
    );
  }
}
