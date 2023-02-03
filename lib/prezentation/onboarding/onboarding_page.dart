import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:salons_app_mobile/event_bus_events/event_bus.dart';
import 'package:salons_app_mobile/event_bus_events/user_done_onboarding_event.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        _buildPageContent(
          title: "Title of introduction page",
          description:
              "Welcome to the app! This is a description of how it works.",
        ),
        _buildPageContent(
          title: "Title of introduction page",
          description:
              "Welcome to the app! This is a description of how it works.",
        ),
        _buildPageContent(
          title: "Title of introduction page",
          description:
              "Welcome to the app! This is a description of how it works.",
        ),
      ],
      showSkipButton: true,
      showNextButton: true,
      skip: const Text("Skip"),
      done: const Text("Done"),
      next: const Text("Next"),
      onDone: () {
        eventBus.fire(UserDoneOnboardingEvent());
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }

  PageViewModel _buildPageContent(
      {required String title, required String description}) {
    return PageViewModel(
      title: "Title of introduction page",
      body: "Welcome to the app! This is a description of how it works.",
      image: const Center(
        child: Icon(Icons.waving_hand, size: 50.0),
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(color: Colors.orange),
        bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      ),
    );
  }
}
