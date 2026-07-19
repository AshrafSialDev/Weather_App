# Brighter Icons and Animated Background for Home Page

The goal is to enhance the visual appeal of the Home page by making the icons more vibrant ("brighter") and adding an animated gradient background that shifts over time.

## Proposed Changes

### lib/Activity/

#### [MODIFY] [home.dart](file:///D:/flutter_project/flutter_application_1/lib/Activity/home.dart)
- **Animated Background**:
    - Implement an `AnimationController` in `_HomeState` to drive the background animation.
    - Create a `Tween` for gradient colors or alignments to create a smooth, shifting effect.
    - Use an `AnimatedBuilder` to wrap the background `Container`.
- **Brighter Icons**:
    - Update `Icon` widgets for Search, Wind, and Humidity to use brighter, more vibrant colors (e.g., `Colors.lightBlueAccent`, `Colors.amberAccent`).
    - Update the main weather icon to have a specific color based on the weather type (e.g., yellow for sun, blue for rain) and increase its size/vibrancy.
    - Potentially add a subtle glow effect using `Shadows` on the icons.

## Verification Plan

### Manual Verification
- Launch the app and observe the Home screen background shifting colors smoothly.
- Verify that icons (Search, Weather, Wind, Humidity) appear more vibrant and are easier to see against the animated background.
- Ensure the animation is smooth and doesn't impact app performance.
