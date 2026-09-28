library;

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Kill switch for the whole experience section. Set to `false` and both the
/// section and its navigation link disappear.
const bool kShowExperienceSection = true;

enum ExperienceKind {
  work('Work'),
  education('Education'),
  other('Other');

  const ExperienceKind(this.label);

  final String label;
}

@immutable
class Experience {
  const Experience({
    required this.role,
    required this.organization,
    required this.period,
    required this.summary,
    this.kind = ExperienceKind.work,
    this.highlights = const <String>[],
    this.icon = FontAwesomeIcons.briefcase,
  });

  /// Job title, degree, or similar.
  final String role;

  /// Company, school, or community.
  final String organization;

  /// Human readable date range, e.g. `2023 — Present`.
  final String period;

  /// One or two sentences describing the work.
  final String summary;

  final ExperienceKind kind;

  /// Optional bullet points.
  final List<String> highlights;

  /// Font Awesome icon. Must be rendered with [FaIcon] rather than [Icon] to
  /// avoid clipping.
  final FaIconData icon;
}

const List<Experience> kExperiences = <Experience>[
  Experience(
    kind: ExperienceKind.education,
    icon: FontAwesomeIcons.graduationCap,
    role:
        'Associate\'s degree, Mechatronics, Robotics, and Automation Engineering',
    organization: 'enghelab-e eslami technical college of tehran',
    period: '2024 — 2026',
    summary:
        'At university, I met professionals and gained useful experience from colleagues and students working on real projects.',
  ),
  Experience(
    role: 'Software Engineer',
    organization: 'SVP',
    period: '2025 — Present',
    summary:
        '''I was responsible for the backend and mobile application, designing and implementing the software layer that connects the vehicle hardware, backend infrastructure, and end users.''',
    highlights: <String>[
      'Designed and developed the backend using Go',
      'Built RESTful APIs for authentication, user management, vehicle management, and data access',
      'Implemented JWT-based authentication and token management',
      'Designed the data layer using PostgreSQL',
      'Used TimescaleDB for efficient storage and querying of time-series vehicle location data',
      'Integrated MQTT communication through EMQX for receiving real-time vehicle data',
      'Implemented WebSocket communication for real-time updates between the backend and mobile application',
      'Implemented time-based pagination for large location datasets',
      'Applied the Ramer–Douglas–Peucker (RDP) algorithm to simplify GPS paths and reduce unnecessary location points when displaying historical routes',
      'Developed the mobile application using Flutter and Dart',
      'Implemented authentication, registration, token handling, and user sessions',
      'Developed vehicle management functionality',
      'Implemented real-time vehicle location tracking',
      'Added historical route visualization and location history',
      'Integrated map functionality for displaying vehicle locations and routes',
      'Implemented real-time vehicle parameter monitoring',
      'Designed the application architecture to communicate with the backend through REST APIs and WebSockets',
      'tested and implemented on a real vehicle',
    ],
  ),
];
