import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/theme/dark_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
  });

  final ProjectConstants project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late final PageController _imageController;

  @override
  void initState() {
    super.initState();

    _imageController = PageController();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _openRepository() async {
    final uri = Uri.tryParse(widget.project.repo);

    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 15.0,
      ),
      decoration: BoxDecoration(
        color: DarkColors.onBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  AnimatedPageView(
                    imageController: _imageController,
                    images: project.screenShots,
                  ),

                  if (project.screenShots.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _imageController,
                          count: project.screenShots.length,
                          effect: const WormEffect(
                            dotHeight: 6,
                            dotWidth: 6,
                            spacing: 6,
                            activeDotColor: Colors.blueAccent,
                            dotColor: DarkColors.onBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: DarkColors.onBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Text(
                      project.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 6.0,
                      children: [
                        ...project.skillNames.map(
                          (skill) => Image.asset(
                            'assets/$skill.png',
                            width: 30,
                            height: 30,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _openRepository,
                      icon: const FaIcon(
                        FontAwesomeIcons.github,
                        size: 22,
                      ),
                      label: const Text(
                        'View on GitHub',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPageView extends StatefulWidget {
  const AnimatedPageView({
    super.key,
    required this.imageController,
    required this.images,
  });

  final PageController imageController;
  final List<String> images;

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView> {
  Timer? _imageTimer;

  int _currentImage = 0;

  bool _isUserDragging = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startImageTimer();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.images != widget.images) {
      _imageTimer?.cancel();

      _currentImage = 0;

      if (widget.imageController.hasClients) {
        widget.imageController.jumpToPage(0);
      }

      _startImageTimer();
    }
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    super.dispose();
  }

  void _startImageTimer() {
    _imageTimer?.cancel();

    if (widget.images.length <= 1) {
      return;
    }

    _imageTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!mounted || _isUserDragging) {
          return;
        }

        if (!widget.imageController.hasClients) {
          return;
        }

        final nextPage = (_currentImage + 1) % widget.images.length;

        _currentImage = nextPage;

        widget.imageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void _stopTimer() {
    _imageTimer?.cancel();
    _imageTimer = null;
  }

  void _restartTimer() {
    _stopTimer();

    if (!mounted) return;

    _startImageTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        color: DarkColors.onBackgroundColor,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white54,
          size: 50,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _isUserDragging = true;
          _stopTimer();
        }

        if (notification is ScrollEndNotification) {
          _isUserDragging = false;
          _restartTimer();
        }

        return false;
      },
      child: PageView.builder(
        controller: widget.imageController,
        itemCount: widget.images.length,

        physics: const PageScrollPhysics(),

        onPageChanged: (index) {
          _currentImage = index;

          if (mounted) {
            setState(() {});
          }

          if (!_isUserDragging) {
            _restartTimer();
          }
        },

        itemBuilder: (context, index) {
          final imageUrl = widget.images[index];

          return _ProjectImage(
            key: ValueKey(imageUrl),
            imageUrl: imageUrl,
          );
        },
      ),
    );
  }
}

class _ProjectImage extends StatelessWidget {
  const _ProjectImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: DarkColors.onBackgroundColor,
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 45,
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          final isLoaded = wasSynchronouslyLoaded || frame != null;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ...previousChildren,
                  ?currentChild,
                ],
              );
            },
            child: isLoaded
                ? KeyedSubtree(
                    key: const ValueKey('image'),
                    child: child,
                  )
                : Shimmer.fromColors(
                    key: const ValueKey('shimmer'),
                    baseColor: DarkColors.headerTextColor,
                    highlightColor: DarkColors.myGrey,
                    child: Container(color: Colors.white),
                  ),
          );
        },
      ),
    );
  }
}
