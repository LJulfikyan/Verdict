class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.type,
  });

  final String title;
  final String subtitle;
  final OnboardingIllustrationType type;
}

enum OnboardingIllustrationType { cards, anonymous, chart }
