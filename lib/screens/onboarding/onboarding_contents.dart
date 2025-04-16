class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Fresh Produce at Your Doorstep",
    image: "assets/onboarding_images/image1.png",
    desc:
        "Get farm-fresh vegetables and fruits delivered right to your home with AgriBox.",
  ),
  OnboardingContents(
    title: "Support Local Farmers",
    image: "assets/onboarding_images/image2.png",
    desc:
        "Empower local farmers by choosing organic produce straight from their fields.",
  ),
  OnboardingContents(
    title: "Order Easily with AgriBox",
    image: "assets/onboarding_images/image3.png",
    desc:
        "Browse categories and place orders anytime, with seamless farm-to-home delivery.",
  ),
];
