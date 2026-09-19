enum ProjectConstants {
  svp(
    repo: "https://github.com/amiralitaherkhany/Smart-Vehicle",
    name: "Smart Vehicle",
    description:
        "A complete smart vehicle tracking and monitoring system connecting vehicle hardware, a Go backend, and a Flutter mobile app for real-time location and telemetry.",
    screenShots: [
      "${_baseUrl}Smart-Vehicle/master/screenshots/1.png",
      "${_baseUrl}Smart-Vehicle/master/screenshots/2.png",
      "${_baseUrl}Smart-Vehicle/master/screenshots/3.png",
      "${_baseUrl}Smart-Vehicle/master/screenshots/4.png",
      "${_baseUrl}Smart-Vehicle/master/screenshots/5.png",
      "${_baseUrl}Smart-Vehicle/master/screenshots/6.png",
    ],
    skillNames: [
      "dart",
      "flutter",
      "go",
      "postgresql",
      "redis",
      "githubactions",
    ],
  ),
  valorantIntel(
    repo: "https://github.com/amiralitaherkhany/valorant-intel",
    name: "Valorant Intel",
    description:
        "A visually rich Flutter app that brings all Valorant in-game assets—agents, guns, maps, and more—right to your fingertips, powered by the Valorant API.",
    screenShots: [
      "${_baseUrl}valorant-intel/master/screenshots/1.png",
      "${_baseUrl}valorant-intel/master/screenshots/2.png",
      "${_baseUrl}valorant-intel/master/screenshots/3.png",
      "${_baseUrl}valorant-intel/master/screenshots/4.png",
      "${_baseUrl}valorant-intel/master/screenshots/5.png",
    ],
    skillNames: [
      "dart",
      "flutter",
      "githubactions",
    ],
  ),
  proTicTacToe(
    repo: "https://github.com/amiralitaherkhany/pro-tic-tac-toe",
    name: "Pro TicTacToe",
    description:
        "A Tic Tac Toe game developed with Kotlin and Jetpack Compose for Android. Built as a fun project to explore modern Android development!",
    screenShots: [
      "${_baseUrl}pro-tic-tac-toe/master/screenshots/1.png",
      "${_baseUrl}pro-tic-tac-toe/master/screenshots/2.png",
      "${_baseUrl}pro-tic-tac-toe/master/screenshots/3.png",
      "${_baseUrl}pro-tic-tac-toe/master/screenshots/4.png",
      "${_baseUrl}pro-tic-tac-toe/master/screenshots/5.png",
    ],
    skillNames: [
      "android",
      "kotlin",
      "jetpackcompose",
      "githubactions",
    ],
  ),
  appleshop(
    repo: "https://github.com/amiralitaherkhany/apple-shop",
    name: "Apple Shop",
    description:
        "A sample Flutter shopping app that demonstrates a simple and responsive design. Users can browse products, view details, and add items to their cart.",
    screenShots: [
      "${_baseUrl}apple-shop/master/screenshots/1.png",
      "${_baseUrl}apple-shop/master/screenshots/2.png",
      "${_baseUrl}apple-shop/master/screenshots/3.png",
      "${_baseUrl}apple-shop/master/screenshots/4.png",
      "${_baseUrl}apple-shop/master/screenshots/5.png",
    ],
    skillNames: [
      "dart",
      "flutter",
    ],
  );

  static const _baseUrl =
      "https://raw.githubusercontent.com/amiralitaherkhany/";
  const ProjectConstants({
    required this.repo,
    required this.name,
    required this.screenShots,
    required this.description,
    required this.skillNames,
  });
  final String name;
  final String repo;
  final String description;
  final List<String> screenShots;
  final List<String> skillNames;
}
