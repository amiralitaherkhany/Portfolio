import 'package:flutter/widgets.dart';

/// A technology shown on the portfolio.
@immutable
class Skill {
  const Skill({
    required this.name,
    required this.displayName,
    required this.category,
  });

  /// Matches the file name in `assets/`, e.g. `flutter.png`.
  final String name;
  final String displayName;
  final SkillCategory category;
}

enum SkillCategory {
  languages('Languages'),
  frameworks('UI & Frameworks'),
  data('Databases'),
  tooling('Tools & DevOps');

  const SkillCategory(this.label);

  final String label;
}

/// Skills are grouped by category instead of being rendered as
/// self-assessed percentage bars.
const List<Skill> kSkills = <Skill>[
  // Languages.
  Skill(name: 'dart', displayName: 'Dart', category: SkillCategory.languages),
  Skill(
    name: 'kotlin',
    displayName: 'Kotlin',
    category: SkillCategory.languages,
  ),
  Skill(name: 'go', displayName: 'Go', category: SkillCategory.languages),

  // UI & frameworks.
  Skill(
    name: 'flutter',
    displayName: 'Flutter',
    category: SkillCategory.frameworks,
  ),
  Skill(
    name: 'jetpackcompose',
    displayName: 'Jetpack Compose',
    category: SkillCategory.frameworks,
  ),
  Skill(
    name: 'android',
    displayName: 'Android',
    category: SkillCategory.frameworks,
  ),

  // Databases.
  Skill(
    name: 'postgresql',
    displayName: 'PostgreSQL',
    category: SkillCategory.data,
  ),
  Skill(name: 'mysql', displayName: 'MySQL', category: SkillCategory.data),
  Skill(name: 'redis', displayName: 'Redis', category: SkillCategory.data),

  // Tools & DevOps.
  Skill(name: 'git', displayName: 'Git', category: SkillCategory.tooling),
  Skill(name: 'docker', displayName: 'Docker', category: SkillCategory.tooling),
  Skill(
    name: 'githubactions',
    displayName: 'GitHub Actions',
    category: SkillCategory.tooling,
  ),
  Skill(name: 'linux', displayName: 'Linux', category: SkillCategory.tooling),
];

/// Skills belonging to [category], in declaration order.
List<Skill> skillsIn(SkillCategory category) => kSkills
    .where((skill) => skill.category == category)
    .toList(growable: false);

/// Maps an asset name such as `githubactions` to a readable label.
///
/// Falls back to the name itself, so a technology without an entry in
/// [kSkills] still renders.
String displayNameFor(String assetName) {
  for (final skill in kSkills) {
    if (skill.name == assetName) return skill.displayName;
  }
  return assetName;
}
